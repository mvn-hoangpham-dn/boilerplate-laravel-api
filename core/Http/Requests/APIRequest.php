<?php

namespace Core\Http\Requests;

use Illuminate\Foundation\Http\FormRequest;
use Illuminate\Contracts\Validation\Validator;
use Core\Exceptions\ValidationException;

class APIRequest extends FormRequest
{
    /**
     * Force request require using application/json
     *
     * @return boolean
     */
    public function wantsJson()
    {
        return true;
    }

    /**
     * Force to custom validation response
     *
     * @param Validator $validator $validator
     *
     * @return boolean
     */
    protected function failedValidation(Validator $validator)
    {
        throw new ValidationException($validator);
    }
}
