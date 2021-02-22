<?php

namespace Modules\Users\Http\Requests;

use Core\Http\Requests\APIRequest;

class ListUserRequest extends APIRequest
{
    /**
     * Get the validation rules that apply to the request.
     *
     * @return array
     */
    public function rules()
    {
        return [
           'page'  => 'int|min:1',
           'limit' => 'int|min:1',
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
