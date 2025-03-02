# Endless Horizon

## Description

Endless Horizon is an application to gather long term trends in packages and services, it pulls information from a number of sources to help you identify and make choices on if a package/service is acceptable for you and your projects.

## Setup

The project is driven by a gnu [`Makefile`](https://www.gnu.org/software/make/), you will need to have an environment in which you can run `Make` and `Docker`, `macos` and `linux` may already come with `make` (if your linux distribution does not, it should be easy enough to install). If you use windows please install [WSL](https://learn.microsoft.com/en-us/windows/wsl/install).

Everything in the project including the PostgreSQL database, Docker, and the web server configuration is hidden behind the Make commands. For example to build the project (which will build the Docker image locally) `make build`, to start the web service `make start`, to see application logs `make logs`, and these commands can be chained in any way you like, for example `make build start logs` will run all three steps one after another.
