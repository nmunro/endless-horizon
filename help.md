# Make Rules

## Help

Prints this help message

Example: `make help`

## dev-tools-check

This is not normally used by developers, however it is defined to check all required tools are installed, other rules may depend on this as they will require things like Docker or another tool to run.

Example: `make dev-tools-check`

## build

This builds the Docker image locally, there are three options

* FORCE: Forces the image to be rebuilt
* SERVICE: Specifies the image to build (web or web-dev, defaults to web-dev)
* COMPOSE_FILE: Specifies which docker-compose file to use, as there may be os/architecture specific differences

Example: `make build FORCE=true`

## start

This starts a Docker service.

* SERVICE: Specifies the image to build (web or web-dev, defaults to web-dev)
* COMPOSE_FILE: Specifies which docker-compose file to use, as there may be os/architecture specific differences

Example: `make start`

## stop

This stops a Docker service.

* SERVICE: Specifies the image to build (web or web-dev, defaults to web-dev)
* COMPOSE_FILE: Specifies which docker-compose file to use, as there may be os/architecture specific differences

Example: `make stop`

## restart

This is simply a convenience rule that calls stop then start.

Example: `make restart`

## lint

This runs `black`, `isort`, and `flake8` over the code base to lint it for clarity, it _will_ rewrite files for you.

* SERVICE: Specifies the image to build (web or web-dev, defaults to web-dev)
* COMPOSE_FILE: Specifies which docker-compose file to use, as there may be os/architecture specific differences

Example: `make lint`

## static

Collects static files.

* SERVICE: Specifies the image to build (web or web-dev, defaults to web-dev)
* COMPOSE_FILE: Specifies which docker-compose file to use, as there may be os/architecture specific differences

Example: `make static`

## migrate

Apply django database migrations.

* SERVICE: Specifies the image to build (web or web-dev, defaults to web-dev)
* COMPOSE_FILE: Specifies which docker-compose file to use, as there may be os/architecture specific differences

Example: `make migrate`

## migrations

Creates django database migrations.

* SERVICE: Specifies the image to build (web or web-dev, defaults to web-dev)
* COMPOSE_FILE: Specifies which docker-compose file to use, as there may be os/architecture specific differences

Example: `make migrations`

## repl

Opens the python repl.

* SERVICE: Specifies the image to build (web or web-dev, defaults to web-dev)
* COMPOSE_FILE: Specifies which docker-compose file to use, as there may be os/architecture specific differences

Example: `make repl`

## shell

Opens the os terminal.

* SERVICE: Specifies the image to build (web or web-dev, defaults to web-dev)
* COMPOSE_FILE: Specifies which docker-compose file to use, as there may be os/architecture specific differences

Example: `make shell`

## test

Runs project tests.

* SRC: The folder in which to run tests
* TEST-CASE: The collection or specific test to run (when omitted it runs all tests)
* SERVICE: Specifies the image to build (web or web-dev, defaults to web-dev)
* COMPOSE_FILE: Specifies which docker-compose file to use, as there may be os/architecture specific differences

Example: `make test TEST-CASE=...`

## clean

Cleans the docker environment by deleting unused/stopped containers.

* IMAGES: Cleans out images if value is `true`
* VOLUMES: Cleans out volumes if value is `true`
* SYSTEM: Cleans out system if value is `true`

Example: `make clean IMAGES=true VOLUMES=true SYSTEM=true`

## logs

View application logs of a docker service.

* SERVICE: Specifies the image to build (web or web-dev, defaults to web-dev)
* COMPOSE_FILE: Specifies which docker-compose file to use, as there may be os/architecture specific differences

Example: `make logs`

## poetry

Runs a poetry command inside the service.

* CMD: The poetry command to run, for example: `add django`
* SERVICE: Specifies the image to build (web or web-dev, defaults to web-dev)
* COMPOSE_FILE: Specifies which docker-compose file to use, as there may be os/architecture specific differences

Example: `make poetry CMD="add django"`

## create-super-user

Creates the super user for managing the admin panel.

* SERVICE: Specifies the image to build (web or web-dev, defaults to web-dev)
* COMPOSE_FILE: Specifies which docker-compose file to use, as there may be os/architecture specific differences

Example: `make create-super-user`

## update

This will update the packages managed by `poetry`.

* SERVICE: Specifies the image to build (web or web-dev, defaults to web-dev)
* COMPOSE_FILE: Specifies which docker-compose file to use, as there may be os/architecture specific differences

Example: `make update`

## requirements

Creates the `requirements.txt` and `requirements-dev.txt` files for use when deploying application.

* SERVICE: Specifies the image to build (web or web-dev, defaults to web-dev)
* COMPOSE_FILE: Specifies which docker-compose file to use, as there may be os/architecture specific differences

Example: `make requirements`

## update-requirements

This runs the update rule followed by the requirements rule to update and output the new requirements files.

Example: `make update-requirements`

## lock

This will regenerate the poetry lock file.

* SERVICE: Specifies the image to build (web or web-dev, defaults to web-dev)
* COMPOSE_FILE: Specifies which docker-compose file to use, as there may be os/architecture specific differences

Example: `make lock`

## startapp

Create a new django application within the current project.

* APP-NAME: The name of the app to create.
* SERVICE: Specifies the image to build (web or web-dev, defaults to web-dev)
* COMPOSE_FILE: Specifies which docker-compose file to use, as there may be os/architecture specific differences

Example: `make startapp APP-NAME="info"`

## db-shell

Opens the database shell for manual SQL wrangling.

* SERVICE: Specifies the image to build (web or web-dev, defaults to web-dev)
* COMPOSE_FILE: Specifies which docker-compose file to use, as there may be os/architecture specific differences

Example: `make db-shell`

## management-command

Runs a django management command.

* CMD: The management command to run
* SERVICE: Specifies the image to build (web or web-dev, defaults to web-dev)
* COMPOSE_FILE: Specifies which docker-compose file to use, as there may be os/architecture specific differences

Example: `make management-command CMD="migrate"`
