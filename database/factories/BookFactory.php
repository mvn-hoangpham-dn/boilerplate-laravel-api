<?php

/** @var \Illuminate\Database\Eloquent\Factory $factory */

use Core\Models\Book;
use Illuminate\Support\Str;
use Faker\Generator as Faker;

$factory->define(Book::class, function (Faker $faker) {
    $title = Str::title($faker->words($nb = 5, $asText = true));
    $slug = Str::slug($title);
    $description = $faker->paragraphs($nb = 3, $asText = true);
    $year = rand(1900, 2020);

    return [
        'title' => $title,
        'slug' => $slug,
        'description' => $description,
        'year' => $year,
        'author_id' => rand(1, 1000),
        'publisher_id' => rand(1, 1000),
    ];
});
