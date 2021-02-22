<?php

use Illuminate\Support\Facades\Route;

$routeGroup = [
    'as'         => 'users.',
    'prefix'     => 'api/v1/users',
    'middleware' => [
        'api',
    ],
    'namespace'  => 'Modules\Users\Http\Controllers',
];

Route::group($routeGroup, function () {
    Route::get('/', 'UserController@list')->name('list');
});
