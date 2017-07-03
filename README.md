## Overview
AT-boilerplate-laravel-web provides you with a massive head start on any size web application. We have put a lot of work into it and we hope it serves you well and saves you time!

## Table of Contents
- [Prerequisites](#prerequisites)
- [Features](#features)
- [Packages](#packages)
- [Code Style Guide](#code-style-guide)
- [Getting started](#getting-started)
    - [Download](#download)
    - [Environment Files](#environment-files)
    - [Composer](#composer)
    - [Create Database](#create-database)
    - [Artisan Commands](#artisan-commands)
    - [PHPUnit](#phpunit)
    - [Login](#login)
- [Resources](#resources)
    - [Version](#version)
    - [From the Source](#from-the-source)
    - [Directory Structure](#directory-structure)
- [What's Next?](#whats-next)
- [Contributing](#contributing)

## Prerequisites
The Laravel framework has a few system requirements. Of course, all of these requirements are satisfied by the Laravel Homestead virtual machine, so it's highly recommended that you use Homestead as your local Laravel development environment.

However, if you are not using Homestead, you will need to make sure your server meets the following requirements:
- PHP >= 5.6.4
- OpenSSL PHP Extension
- PDO PHP Extension
- Mbstring PHP Extension
- Tokenizer PHP Extension
- XML PHP Extension

## Features
- [Laravel feature](https://laravel.com/docs/5.4)
- Maintenance middleware
- Client code middleware
- Repository pattern
- Service pattern

## Packages
| Name        | Description           | Version  |
| ------------- | ------------- |:-----:|
| [prettus/l5-repository](https://github.com/andersao/l5-repository)      | Repositories is used to abstract the data layer, making our application more flexible to maintain. | 2.6.18 |
| [fzaninotto/faker](https://github.com/fzaninotto/Faker) | Faker is a PHP library that generates fake data for you |   1.4 |
| [phpunit/phpunit](https://packagist.org/packages/phpunit/phpunit) | PHPUnit is a programmer-oriented testing framework for PHP. It is an instance of the xUnit architecture for unit testing frameworks. |    4.0 |

## Code Style Guide
The Laravel framework itself doesn’t impose standards on how you should name your variables or where to put files. As long as it can be loaded by Composer, it will technically run inside the application. However, developers are encouraged to study and follow the following PSR standards:
- [PSR-1](http://www.php-fig.org/psr/psr-1/)
- [PSR-2](http://www.php-fig.org/psr/psr-2/)
- [PSR-4](http://www.php-fig.org/psr/psr-4/)

## Getting started
### Download
Download the files above and place on your server. (This project was developed on Laravel Homestead and I highly recommend you use either that or Laravel Velet, to get the optimal server configuration and no errors through installation.)

### Environment Files
This package ships with a .env.example file in the root of the project.

You must rename this file to just .env

Note: Make sure you have hidden files shown on your system.

### Composer
Laravel project dependencies are managed through the PHP Composer tool. The first step is to install the depencencies by navigating into your project in terminal and typing this command:
```json
composer install
```

### Create Database
You must create your database on your server and on your .env file update the following lines:

```json
DB_CONNECTION=mysql
DB_HOST=127.0.0.1
DB_PORT=3306
DB_DATABASE=homestead
DB_USERNAME=homestead
DB_PASSWORD=secret
```

Change these lines to reflect your new database settings.

### Artisan Commands
The first thing we are going to so is set the key that Laravel will use when doing encryption.

```json
php artisan key:generate
```

You should see a green message stating your key was successfully generated. As well as you should see the APP_KEY variable in your .env file reflected.

It's time to see if your database credentials are correct.

We are going to run the built in migrations to create the database tables:

```json
php artisan migrate
```

You should see a message for each table migrated, if you don't and see errors, than your credentials are most likely not correct.

We are now going to set the administrator account information. To do this you need to navigate to this file and change the name/email/password of the Administrator account.

You can delete the other dummy users, but do not delete the administrator account or you will not be able to access the backend.

Now seed the database with:

```json
php artisan db:seed
```

You should get a message for each file seeded, you should see the information in your database tables.

### PHPUnit
After your project is installed, make sure you run the test suite to make sure all of the parts are working correctly. From the root of your project run:

```json
phpunit
```

You will see a dot(.) appear for each of the hundreds of tests, and then be provided with the amount of passing tests at the end. There should be no failures with a fresh install.

### Login
After your project is installed and you can access it in a browser, click the login button on the right of the navigation bar.

The administrator credentials are:

```json
Username: admin@admin.com
Password: 23456780
```

You will be automatically redirected to the backend. If you changed these values in the seeder prior, then obviously use the ones you updated to.

## Resources
### Version
- [Laravel framework 5.4](https://laravel.com/docs/5.4)

### From the Source
- [Laravel Website](https://laravel.com/)
- [Laravel Documentation](https://laravel.com/docs/5.4)

### Directory Structure
- [Laravel sourcesource structure](https://laravel.com/docs/5.4/structure)

## What's Next?
At this point you have all that you need, you can browse the code base and build the rest of your application the way you normally would.

## Contributing
Thank you for considering contributing to the Laravel Boilerplate project! Please feel free to make any pull requests.
For bugs, questions and discussions please use the [GitHub Issues](https://github.com/AsianTechInc/AT-boilerplate-laravel-web/issues).