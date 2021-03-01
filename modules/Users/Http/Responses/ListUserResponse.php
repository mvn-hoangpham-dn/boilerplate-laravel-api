<?php

namespace Modules\Users\Http\Responses;

use Illuminate\Http\Resources\Json\JsonResource;

class ListUserResponse extends JsonResource
{
    /**
     * Transform the resource into an array.
     *
     * @param \Illuminate\Http\Request $request request
     *
     * @return array
     *
     * @SuppressWarnings(PHPMD.UnusedFormalParameter)
     */
    public function toArray($request)
    {
        return [
           'id'        => (int) $this->id,
        ];
    }
}
