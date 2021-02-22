#!/usr/bin/env bash
set -xeuo pipefail

source aws-envs.sh

rm admin-ecs.txt || true

ECS_TASK_FAMILY=${AWS_ENV}-boilerplate-task-blue-ecs-be

#Get current task definition arn before deploy to rollback purpose
CURRENT_TASK_DEFINITION_ARN=$(aws ecs describe-services --cluster $ECS_CLUSTER_NAME --services $BACKEND_SERVICE_NAME --query 'services[*].taskDefinition' --output text)

#Get log stream prefix
CURRENT_LOG_STREAM_PREFIX=$(aws ecs describe-task-definition --task-definition ${ECS_TASK_FAMILY} --region ${AWS_DEFAULT_REGION} --query 'taskDefinition.containerDefinitions[0].logConfiguration.options' | jq -r '.["awslogs-stream-prefix"]')

#Create task definition with new log stream
CONTAINER_DEFINITION_MAP_JSON=$(aws ecs describe-task-definition --task-definition ${ECS_TASK_FAMILY} --region ${AWS_DEFAULT_REGION} --query 'taskDefinition.containerDefinitions[]' | sed "s/${CURRENT_LOG_STREAM_PREFIX}/${IMAGE_TAG}/")

#Get temporary revision number
TEMP_REVISION=$(aws ecs describe-services --cluster $ECS_CLUSTER_NAME --services $BACKEND_SERVICE_NAME --query 'services[*].taskDefinition' --output text | awk -F: '{print $7}')

#Get cpu & memory
CPU=$(aws ecs describe-task-definition --task-definition ${ECS_TASK_FAMILY} --region ${AWS_DEFAULT_REGION} --query 'taskDefinition.containerDefinitions[0].cpu' --output text)
MEMORY=$(aws ecs describe-task-definition --task-definition ${ECS_TASK_FAMILY} --region ${AWS_DEFAULT_REGION} --query 'taskDefinition.containerDefinitions[0].memory' --output text)

#Register new task definition
aws ecs register-task-definition --family ${ECS_TASK_FAMILY} --container-definitions "${CONTAINER_DEFINITION_MAP_JSON}" \
--execution-role-arn arn:aws:iam::${AWS_ACCOUNT_ID}:role/${AWS_DEFAULT_REGION}-${AWS_ENV}-boilerplate-execute-task-role-ecs \
--task-role-arn arn:aws:iam::${AWS_ACCOUNT_ID}:role/${AWS_DEFAULT_REGION}-${AWS_ENV}-boilerplate-task-role-ecs \
--requires-compatibilities FARGATE \
--network-mode awsvpc \
--cpu ${CPU} \
--memory ${MEMORY} \
--region ${AWS_DEFAULT_REGION} --profile boilerplate-${AWS_ENV}

#Deploy with latest task definition, it will create newer revision of task definition
docker run --env AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID} --env AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY} --env AWS_SESSION_TOKEN=${AWS_SESSION_TOKEN} fabfuel/ecs-deploy:1.10.0 ecs deploy ${ECS_CLUSTER_NAME} ${BACKEND_SERVICE_NAME} --task ${ECS_TASK_FAMILY} --region ${AWS_DEFAULT_REGION} \
-s admin-ecs APP_NAME /${AWS_ENV}/boilerplate/APP_NAME \
-s admin-ecs APP_ENV /${AWS_ENV}/boilerplate/APP_ENV \
-s admin-ecs APP_GROONGA /${AWS_ENV}/boilerplate/APP_GROONGA \
-s admin-ecs APP_KEY /${AWS_ENV}/boilerplate/APP_KEY \
-s admin-ecs APP_DEBUG /${AWS_ENV}/boilerplate/APP_DEBUG \
-s admin-ecs APP_URL /${AWS_ENV}/boilerplate/APP_URL \
-s admin-ecs LOG_CHANNEL /${AWS_ENV}/boilerplate/LOG_CHANNEL \
-s admin-ecs DB_CONNECTION /${AWS_ENV}/boilerplate/DB_CONNECTION \
-s admin-ecs DB_HOST /${AWS_ENV}/boilerplate/DB_HOST \
-s admin-ecs DB_DATABASE /${AWS_ENV}/boilerplate/DB_DATABASE \
-s admin-ecs DB_PORT /${AWS_ENV}/boilerplate/DB_PORT \
-s admin-ecs DB_USERNAME /${AWS_ENV}/boilerplate/DB_USERNAME \
-s admin-ecs DB_PASSWORD /${AWS_ENV}/boilerplate/DB_PASSWORD \
-s admin-ecs PROJECT_NAME /${AWS_ENV}/boilerplate/PROJECT_NAME \
-s admin-ecs BROADCAST_DRIVER /${AWS_ENV}/boilerplate/BROADCAST_DRIVER \
-s admin-ecs CACHE_DRIVER /${AWS_ENV}/boilerplate/CACHE_DRIVER \
-s admin-ecs QUEUE_CONNECTION /${AWS_ENV}/boilerplate/QUEUE_CONNECTION \
-s admin-ecs SESSION_DRIVER /${AWS_ENV}/boilerplate/SESSION_DRIVER \
-s admin-ecs SESSION_LIFETIME /${AWS_ENV}/boilerplate/SESSION_LIFETIME \
-s admin-ecs AWS_BUCKET /${AWS_ENV}/boilerplate/AWS_BUCKET \
-s admin-ecs CENTRAL_DOMAIN /${AWS_ENV}/boilerplate/CENTRAL_DOMAIN \
-s admin-ecs FIREBASE_SERVER_URL /${AWS_ENV}/boilerplate/FIREBASE_SERVER_URL \
-s admin-ecs FIREBASE_SERVER_KEY /${AWS_ENV}/boilerplate/FIREBASE_SERVER_KEY \
-s admin-ecs JWT_SECRET /${AWS_ENV}/boilerplate/JWT_SECRET \
-s admin-ecs AWS_ACCESS_KEY_ID /${AWS_ENV}/boilerplate/AWS_ACCESS_KEY_ID \
-s admin-ecs AWS_SECRET_ACCESS_KEY /${AWS_ENV}/boilerplate/AWS_SECRET_ACCESS_KEY \
-s admin-ecs CLOUDWATCH_GROUP /${AWS_ENV}/boilerplate/CLOUDWATCH_GROUP \
-s admin-ecs CLOUDWATCH_STREAM /${AWS_ENV}/boilerplate/CLOUDWATCH_STREAM \
--exclusive-env \
--timeout 900 \
--command admin-ecs "" \
-t $IMAGE_TAG || echo $? > admin-ecs.txt

if [[ -f admin-ecs.txt ]];
then
    echo "Deploy service fails. Rollback:"
    docker run --env AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID} --env AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY} --env AWS_SESSION_TOKEN=${AWS_SESSION_TOKEN} fabfuel/ecs-deploy:1.10.0 ecs deploy ${ECS_CLUSTER_NAME} ${BACKEND_SERVICE_NAME} --task ${CURRENT_TASK_DEFINITION_ARN} --region ${AWS_DEFAULT_REGION}
    exit 1
else
    echo "Deployed Successful - Update latest tag"
    aws ssm put-parameter --name "/${AWS_ENV}/boilerplate/CURRENT_IMAGE_TAG_BE" --value "${IMAGE_TAG}" --key-id "arn:aws:kms:ap-northeast-1:${AWS_ACCOUNT_ID}:key/${AWS_BOILERPLATE_KMS}" --type "SecureString" --overwrite --region ap-northeast-1
    echo "Deregister TEMP_REVISION"
    aws ecs deregister-task-definition --task-definition "${ECS_TASK_FAMILY}:${TEMP_REVISION}" --region ${AWS_DEFAULT_REGION} --profile boilerplate-$AWS_ENV  > /dev/null
fi
