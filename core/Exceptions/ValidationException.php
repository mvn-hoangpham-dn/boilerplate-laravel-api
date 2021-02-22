<?php

namespace Core\Exceptions;

use Exception;
use Core\Traits\APIResponser;
use Illuminate\Contracts\Validation\Validator;

class ValidationException extends Exception
{
    use APIResponser;

    protected $validator;

    protected $code = 422;

    /**
     * Constructor
     *
     * @param Validator $validator validator
     */
    public function __construct(Validator $validator)
    {
        $this->validator = $validator;
    }

    /**
     * Render
     *
     * @return JsonResponse
     */
    public function render()
    {
        $errors = array();
        foreach ($this->validator->errors()->getMessages() as $key => $error) {
            $msg = new \stdClass();
            $msg->key = $key;
            $msg->id = reset($error);
            $msg->params = array();
            array_push($errors, $msg);
        }

        return $this->validateErrorResponse($errors, $this->code);
    }
}
