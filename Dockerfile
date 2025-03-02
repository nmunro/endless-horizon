FROM python:3.13 AS dev
# Configure Poetry

ENV PYTHONUNBUFFERED=1
ENV PIP_DISABLE_PIP_VERSION_CHECK=1
ENV PYTHONDONTWRITEBYTECODE=1
ENV POETRY_VERSION=2.1.1
ENV POETRY_HOME=/opt/poetry
ENV POETRY_VENV=/opt/poetry-venv
ENV POETRY_CACHE_DIR=/opt/.cache
ENV PATH="${PATH}:${POETRY_VENV}/bin"

WORKDIR /app/endlesshorizon
RUN apt update -y && apt upgrade -y && apt install -y postgresql

# Install poetry separated from system interpreter
RUN python3 -m venv $POETRY_VENV \
    && $POETRY_VENV/bin/pip install -U pip setuptools wheel \
    && $POETRY_VENV/bin/pip install poetry==${POETRY_VERSION}

COPY . /app/endlesshorizon
RUN poetry install && poetry lock && poetry export -f requirements.txt --output requirements.txt
RUN groupadd -r docker && useradd -r -m -g docker docker
RUN chown -R docker /opt
ENV PYTHONPATH $PYTHONPATH:/app

FROM python:3.13 AS prod

ENV PYTHONUNBUFFERED=1
ENV PIP_DISABLE_PIP_VERSION_CHECK=1
ENV PYTHONDONTWRITEBYTECODE=1

WORKDIR /app/endlesshorizon
RUN apt update -y && apt upgrade -y

COPY . /app/end# Help
    #
    #Application help goes hereless_horizon
COPY --from=dev /app/endlesshorizon/requirements.txt .

RUN pip install -r requirements.txt
RUN groupadd -r docker && useradd -r -m -g docker docker

