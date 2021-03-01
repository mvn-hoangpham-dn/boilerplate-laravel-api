<?php

namespace Modules\Users\Repositories;

use Modules\Users\Models\User;
use Core\Repositories\Repository;
use Illuminate\Support\Facades\Cache;
use Modules\Users\Http\Requests\ListUserRequest;
use Modules\Users\Http\Requests\RegisterUserRequest;
use Modules\Users\Repositories\Interfaces\UserRepositoryInterface;

/**
 * UserRepository class
 */
class UserRepository extends Repository implements UserRepositoryInterface
{
    /**
     * GetModel function
     *
     * @return void
     */
    public function getModel()
    {
        return User::class;
    }

    /**
     * List function
     *
     * @param ListUserRequest $request request
     *
     * @return Collection
     */
    public function list(ListUserRequest $request)
    {
        return User::get();
    }

    /**
     * Register function
     *
     * @param RegisterUserRequest $request request
     *
     * @return Collection
     */
    public function register(RegisterUserRequest $request)
    {
        return User::create($request->toArray());
    }
}
