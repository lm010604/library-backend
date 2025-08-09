# Library RB

This repository contains a Ruby on Rails application. You can run the app with Docker Compose using the provided `docker-compose.yml`.

## Prerequisites

- Docker and Docker Compose
- Environment variables:
  - `RAILS_MASTER_KEY`
  - `POSTGRES_PASSWORD`

Create a `.env` file in the project root and define these variables so Docker
Compose can read them automatically:

```
RAILS_MASTER_KEY=your_master_key
POSTGRES_PASSWORD=choose_a_password
```

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

