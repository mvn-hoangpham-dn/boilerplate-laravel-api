<?php

namespace Modules\Users\Repositories\Interfaces;

use Modules\Users\Http\Requests\ListUserRequest;

/**
 * UserRepositoryInterface interface
 */
interface UserRepositoryInterface
{
    /**
     * GetModel function
     *
     * @return void
     */
    public function getModel();

    /**
     * List function
     *
     * @param ListUserRequest $request request
     *
     * @return Collection
     */
    public function list(ListUserRequest $request);
}
