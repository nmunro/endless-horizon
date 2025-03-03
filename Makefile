.PHONY: build clean clean-docker clean-docs docs repl test shell start stop lint migrate migrations dev-tools-check logs static poetry startapp create-super-user restart lock update update-requirements db-shell management-command
.DEFAULT_GOAL: build

REPORT := $(or $(REPORT),report -m)
GIT_CHANGED_PYTHON_FILES := $(shell git diff --name-only -- '***.py')
DEV_TOOLS := $(and $(shell which docker git pandoc lynx))
COMPOSE_FILE := 'docker-compose.yml'
RUNNING_CONTAINERS := $(shell docker ps -a -q -f name="endlesshorizon-*")
SERVICE := $(or $(SERVICE),web-dev)
SRC := $(or $(SRC),.)
CMD := $(or $(CMD),)

# define standard colors
ifneq ($(TERM),)
    GREEN        := $(shell tput setaf 2)
    RESET        := $(shell tput sgr0)

else
    GREEN        := ""
    RESET        := ""

endif

help: dev-tools-check
	@pandoc help.md | lynx -dump -stdin

dev-tools-check:
ifeq ($(DEV_TOOLS),)
	$(error Some of your dev tools are missing, unable to proceed)
endif

build: dev-tools-check
ifeq ($(FORCE),true)
	@docker container rm -f $(SERVICE)
	@docker container prune
endif
	@docker compose -f $(COMPOSE_FILE) build $(SERVICE)

start: dev-tools-check
	@docker compose -f $(COMPOSE_FILE) up $(SERVICE) -d --remove-orphans

stop: dev-tools-check
	@docker compose -f $(COMPOSE_FILE) down $(SERVICE)

restart: stop start

lint:
ifeq ($(SERVICE),web-dev)
	@$(foreach file, $(GIT_CHANGED_PYTHON_FILES), $(shell docker compose -f $(COMPOSE_FILE) run --rm $(SERVICE) /bin/bash -c "poetry run black ${file} && poetry run isort ${file} && poetry run flake8 ${file}"))
else
	$(error Command not available for service: '$(SERVICE)')
endif

static: dev-tools-check
	@docker compose -f $(COMPOSE_FILE) run --rm $(SERVICE) poetry run python manage.py collectstatic --settings=endlesshorizon.settings.dev

migrate: dev-tools-check
	@docker compose -f $(COMPOSE_FILE) run --rm $(SERVICE) poetry run python manage.py migrate --settings=endlesshorizon.settings.dev

migrations: dev-tools-check
	@docker compose -f $(COMPOSE_FILE) run --rm $(SERVICE) poetry run python manage.py makemigrations --settings=endlesshorizon.settings.dev $(ARGS)

repl: dev-tools-check
	@docker compose -f $(COMPOSE_FILE) run --rm $(SERVICE) poetry run python manage.py shell --settings=endlesshorizon.settings.dev

shell:
	@docker compose -f $(COMPOSE_FILE) run --rm $(SERVICE) /bin/bash

test: dev-tools-check
	@rm -rf coverage
ifneq ($(and $(TEST-CASE),$(SRC)),)
	@docker compose -f $(COMPOSE_FILE) run --rm $(SERVICE) poetry run coverage run --source=$(SRC) --branch ./manage.py test --settings=endlesshorizon.settings.test --no-input $(TEST-CASE); docker compose -f $(COMPOSE_FILE) run --rm $(SERVICE) poetry run coverage $(REPORT)
else ifneq ($(SRC),)
	@docker compose -f $(COMPOSE_FILE) run --rm $(SERVICE) poetry run coverage run --source=$(SRC) --branch ./manage.py test --settings=endlesshorizon.settings.test --no-input; docker compose -f $(COMPOSE_FILE) run --rm $(SERVICE) poetry run coverage $(REPORT)
else ifneq ($(TEST-CASE),)
	@docker compose -f $(COMPOSE_FILE) run --rm $(SERVICE) poetry run coverage run --branch ./manage.py test --settings=endlesshorizon.settings.test --no-input $(TEST-CASE) --parallel
else
	@docker compose -f $(COMPOSE_FILE) run --rm $(SERVICE) poetry run coverage run --branch ./manage.py test --settings=endlesshorizon.settings.test --no-input --parallel
endif
	@rm -rf .coverage.*

clean:
	@docker container prune -f

ifeq ($(IMAGES),true)
	@docker image prune -fa
	@docker builder prune -fa
endif

ifeq ($(VOLUMES),true)
	@docker volume prune -fa
endif

ifeq ($(SYSTEM),true)
	@docker system prune -fa
	@docker builder prune -fa
endif

logs:
	@docker compose -f $(COMPOSE_FILE) logs -f $(SERVICE)

poetry:
ifeq ($(SERVICE),web-dev)
	@docker compose -f $(COMPOSE_FILE) run --rm $(SERVICE) poetry $(CMD)
else
	$(error Command not available for service: '$(SERVICE)')
endif

create-super-user:
	@docker compose -f $(COMPOSE_FILE) run --rm $(SERVICE) poetry run python manage.py createsuperuser --settings=endlesshorizon.settings.dev

requirements:
	@docker compose -f $(COMPOSE_FILE) run --rm $(SERVICE) poetry export -f requirements.txt -o requirements.txt
	@docker compose -f $(COMPOSE_FILE) run --rm $(SERVICE) poetry export --with dev -f requirements.txt -o requirements-dev.txt

update-requirements: update requirements

lock: dev-tools-check
ifeq ($(SERVICE),web-dev)
	@[ ! -d "poetry.lock" ] && rm poetry.lock || true
	@docker compose -f $(COMPOSE_FILE) run --rm $(SERVICE) /bin/bash -c "poetry lock --no-update"
else
	$(error Command not available for service: '$(SERVICE)')
endif

update: dev-tools-check
ifeq ($(SERVICE),web-dev)
	@docker compose -f $(COMPOSE_FILE) run --rm $(SERVICE) poetry update
	@make lock
else
	$(error Command not available for service: '$(SERVICE)')
endif

startapp: dev-tools-check
ifeq ($(SERVICE),web-dev)
	@docker compose -f $(COMPOSE_FILE) run --rm $(SERVICE) poetry run python manage.py startapp $(APP-NAME)
else
	$(error Command not available for service: '$(SERVICE)')
endif

db-shell: dev-tools-check
ifeq ($(SERVICE),web-dev)
	@docker compose -f $(COMPOSE_FILE) run --rm $(SERVICE) poetry run python manage.py dbshell --settings=endlesshorizon.settings.dev
else
	$(error Command not available for service: '$(SERVICE)')
endif

management-command: dev-tools-check
ifeq ($(CMD),)
	$(error You must provide a CMD)
endif

ifeq ($(SERVICE),web-dev)
	@docker compose -f $(COMPOSE_FILE) run --rm $(SERVICE) poetry run python manage.py $(CMD) --settings=endlesshorizon.settings.dev
else
	$(error Command not available for service: '$(SERVICE)')
endif
