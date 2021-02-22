## Overview
CircleCI for auto deploying to AWS

## Table of Contents
- [Environments](#environments)
- [Getting started](#getting-started)
    - [Prepare](#prepare)
    - [ECS](#fork)
    - [EC2](#migrating)

## Environments
| Branch          | Environment |
| --------------- | ----------- |
| feature/sprintX | Dev         |
| develop         | Staging     |
| master          | Production  |

## Getting started
### Prepare (Its Infra's team task)
- Environment variables (normally located at .env) should be stored at [AWS System Managers](https://ap-northeast-1.console.aws.amazon.com/systems-manager/parameters/?region=ap-northeast-1&tab=Table) by `terraform`.
- AWS for each Environments:
| env                      | Environment | name                         |
| ------------------------ | ----------- | ---------------------------- |
| AWS_ACCOUNT_ID           | DEV         | AWS_ACCOUNT_ID_DEV           |
| AWS_IAM_ROLE_EXTERNAL_ID | DEV         | AWS_IAM_ROLE_EXTERNAL_ID_DEV |
| AWS_KMS                  | DEV         | AWS_KMS_DEV                  |
| AWS_ACCOUNT_ID           | STG         | AWS_ACCOUNT_ID_STG           |
| AWS_IAM_ROLE_EXTERNAL_ID | STG         | AWS_IAM_ROLE_EXTERNAL_ID_STG |
| AWS_KMS                  | STG         | AWS_KMS_STG                  |
| AWS_ACCOUNT_ID           | PRD         | AWS_ACCOUNT_ID_PRD           |
| AWS_IAM_ROLE_EXTERNAL_ID | PRD         | AWS_IAM_ROLE_EXTERNAL_ID_PRD |
| AWS_KMS                  | PRD         | AWS_KMS_PRD                  |
| AWS_ACCESS_KEY_ID        |             | AWS_ACCESS_KEY_ID            |
| AWS_SECRET_ACCESS_KEY    |             | AWS_SECRET_ACCESS_KEY        |
- AWS Role for deployment
    - Attach AWS_IAM_ROLE_EXTERNAL_ID to Trust Relationship of this role.


### Steps
- Assume Role: `ops/assume.sh`
    - Collect AWS environments above and push to Circle CI
    https://app.circleci.com/settings/project/github/monstar-lab-consulting/{PROJECT_NAME}/environment-variables
    - `AWS_IAM_ROLE_EXTERNAL_ID` is any string, add it to AWS deploy role.
    Example: `circleci-dev-external-id`
    ```
    "Action": "sts:AssumeRole",
      "Condition": {
        "StringEquals": {
          "sts:ExternalId": "circleci-dev-external-id"
        }
      }
    ```
- Get [ECR](https://ap-northeast-1.console.aws.amazon.com/ecr/repositories?region=ap-northeast-1) informations
- Build and Push Images to ECR: `push.sh`
    - In file `push.sh`, we need to find and modify ECR URL: `BACKEND_ECR_URL` to the ECR name you have got above.
- Deploy: `deploy.sh`
#### ECS
    - Get [ECS_TASK_FAMILY](https://ap-northeast-1.console.aws.amazon.com/ecs/home?region=ap-northeast-1#/taskDefinitions). Example: dev-boilerplate-task-blue-ecs-be
    - Update `ECS_TASK_FAMILY` in `deploy.sh` to value you have got above: dev-boilerplate-task-blue-ecs-be
    - Update `execution-role-arn, task-role-arn` in `Register new task definition` scope.
    - Update environments in `#Deploy with latest task definition` scope.
#### EC2
- TBD
