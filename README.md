# Library RB

This repository contains a Ruby on Rails application. You can run the app with Docker Compose using the provided `docker-compose.yml`.

## Prerequisites

- Docker and Docker Compose
- Environment variables:
  - `RAILS_MASTER_KEY`
  - `POSTGRES_PASSWORD`

## Running with Docker Compose

Build and start the application and database services:

```sh
docker compose up --build
```

The Rails server will be accessible at `http://localhost:3000` and will connect to the bundled Postgres database container.

## Tests

Run the test suite with:

```sh
bundle exec rake test
```

