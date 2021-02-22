<?php

namespace Modules\Users\Models;

use Illuminate\Database\Eloquent\Model;

/**
 * User class
 */
class User extends Model
{
    /**
     * The table associated with the model.
     *
     * @var string
     */
    protected $table = 'users';

    protected $fillable = [
        'name',
    ];
}
