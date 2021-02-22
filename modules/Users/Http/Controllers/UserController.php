<?php

namespace Modules\Users\Http\Controllers;

use Core\Http\Controllers\Controller;
use Modules\Users\Repositories\UserRepository;
use Modules\Users\Http\Requests\ListUserRequest;
use Modules\Users\Http\Responses\ListUserResponse;

/**
 * UserController class
 */
class UserController extends Controller
{
    private $userRepo;

    /**
     * Construct function
     *
     * @param UserRepository $userRepo UserRepository
     */
    public function __construct(UserRepository $userRepo)
    {
        $this->userRepo = $userRepo;
    }

    /**
     * List function
     *
     * @param ListUserRequest $request ListUserRequest
     *
     * @return JsonCollection
     */
    public function list(ListUserRequest $request)
    {
        $users = $this->userRepo->list($request);
        $responses = ListUserResponse::collection($users);

        return $this->successResponse($responses);
    }
}
