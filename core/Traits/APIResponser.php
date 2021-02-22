<?php

namespace Core\Traits;

trait APIResponser
{
    /**
     * Response success by json.
     *
     * @param $data data
     * @param $code code
     *
     * @return \Illuminate\Http\JsonResponse
     */
    protected function successResponse($data = null, $code = 200)
    {
        if (is_null($data)) {
            return response()->json([
                'message'   => 'common.successfully'
            ], $code);
        }
        return response()->json([
            'message'   => 'common.successfully',
            'data'      => $data,
        ], $code);
    }

    /**
     * Response error(s) by json.
     *
     * @param $id     id
     * @param $params params
     * @param $errors errors
     * @param $code   code
     *
     * @return \Illuminate\Http\JsonResponse
     */
    protected function errorResponse($id, $params, $errors = [], $code = 400)
    {
        $response = [
            'id'        => $id,
            'params'    => $params,
            'errors'    => $errors,
        ];

        return response()->json($response, $code);
    }

    /**
     * Response error(s) validate by json.
     *
     * @param $errors errors
     * @param $code   code
     *
     * @return \Illuminate\Http\JsonResponse
     */
    protected function validateErrorResponse($errors, $code = 422)
    {
        $response = [
            'id'        => "common.validation",
            'params'    => [],
            'errors'    => $errors,
        ];

        return response()->json($response, $code);
    }
}
