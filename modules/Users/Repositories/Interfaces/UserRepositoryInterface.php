<?php

namespace Modules\Users\Repositories\Interfaces;

use Modules\Users\Http\Requests\ListUserRequest;
use Modules\Users\Http\Requests\RegisterUserRequest;

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

    /**
     * Register function
     *
     * @param RegisterUserRequest $request request
     *
     * @return Collection
     */
    public function register(RegisterUserRequest $request);
}
