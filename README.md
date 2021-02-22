## Overview
AT-boilerplate-laravel-api provides you with a massive head start on any size web application. We have put a lot of work into it and we hope it serves you well and saves you time!

## Table of Contents
- [Prerequisites](#prerequisites)
- [Features](#features)
- [Getting started](#getting-started)
    - [Fork](#fork)
    - [Migrating](#migrating)
- [Resources](#resources)
    - [Version](#version)
    - [From the Source](#from-the-source)
    - [Directory Structure](#directory-structure)
- [Autodeploy](#autodeploy)
- [Todos](#todos)
    - [Autodeploying Local Server](#autodeploying-local-server)
    - [Authentication](#authentication)
    - [Best Practices](#best-practices)
- [Contributing](#contributing)

## Prerequisites
make sure your server meets the following requirements:
- Docker / Docker Desktop (tested on v2.3.0.2)
- Docker compose

## Features
- [Laravel feature](https://laravel.com/docs/8.x)
- Clean Architecture - HMVC
- API document (Swagger: `endpoint/swagger.html/`)
- Redis
- Database: Postgres
- Webserver: Nginx

## Getting started
### Fork
Fork This repository

### Migrating
```
- make all-images env=local
- make up-all env=local
```

## API document

## Resources
### Version
- [Laravel framework 8.x](https://laravel.com/docs/8.x)

### From the Source
- [Laravel Website](https://laravel.com/)
- [Laravel Documentation](https://laravel.com/docs/8.x)

### Directory Structure
- HMVC

## Autodeploy
- [Autodeploy using circleCI](https://github.com/monstar-lab-consulting/boilerplate-laravel-api/blob/master/ops/README.md)

## Todos
### Autodeploying Local Server
- TODO
### Authentication
- TODO
### Best practices
- FCM
- Twilio
- Payment
- Cloudwatch to Slack

## Contributing
Thank you for considering contributing to the Laravel Boilerplate project! Please feel free to make any pull requests.
For bugs, questions and discussions please use the [GitHub Issues](https://github.com/AsianTechInc/AT-boilerplate-laravel-web/issues).