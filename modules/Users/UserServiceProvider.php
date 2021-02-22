<?php

namespace Modules\Users;

use Modules\Users\Repositories\Interfaces\UserRepositoryInterface;
use Modules\Users\Repositories\UserRepository;
use Illuminate\Support\ServiceProvider;

/**
 * UserServiceProvider class
 */
class UserServiceProvider extends ServiceProvider
{
    /**
     * Bootstrap any application services.
     *
     * @return void
     */
    public function boot()
    {
        //
    }

    /**
     * Register any application services.
     *
     * @return void
     */
    public function register()
    {
        $this->app->bind(
            UserRepositoryInterface::class,
            UserRepository::class
        );
    }
}
