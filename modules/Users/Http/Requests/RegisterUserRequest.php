<?php

namespace Modules\Users\Http\Requests;

use Core\Http\Requests\APIRequest;

class RegisterUserRequest extends APIRequest
{
    /**
     * Get the validation rules that apply to the request.
     *
     * @return array
     */
    public function rules()
    {
        return [
           'name'     => 'required',
           'email'    => 'required',
           'password' => 'required'
        ];
    }

    /**
     * Get the error messages for the defined validation rules.
     *
     * @return array
     */
    public function messages()
    {
        return [
            //
        ];
    }
}
