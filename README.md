# Demo Go app with Postgres dependency

This is a small demo web application built with Go language that demonstrates the use of Postgres database with Go. The app allows users to transact using an HTML frontend on a browser, and the transactions are recorded on the Postgres database.

## Installation

There are several ways to install and run the app:

### Option 1: Using Go CLI

1. Clone the repository: `git clone https://github.com/cldcvr/codepipes-tutorials.git`

2. Navigate to the root directory of the app: `cd apps/04-golang-pgsql`

3. Start the app using Go CLI: `go run main.go`

4. Open a browser and go to `http://localhost:3000` to use the app.

### Option 2: Using Docker

1. Clone the repository: `git clone https://github.com/cldcvr/codepipes-tutorials.git`

2. Navigate to the root directory of the app: `cd apps/04-golang-pgsql`

3. Build the Docker image using the Dockerfile: `docker build -t demo-go-app .`

4. Start the app using Docker: `docker run -p 8080:8080 demo-go-app`

5. Open a browser and go to `http://localhost:3000` to use the app.

### Option 3: Using Docker Compose

1. Clone the repository: `git clone https://github.com/cldcvr/codepipes-tutorials.git`

2. Navigate to the root directory of the app: `cd apps/04-golang-pgsql`

3. Start the app and its dependencies using Docker Compose: `docker-compose up -d`

4. Open a browser and go to `http://localhost:3000` to use the app.

### Option 4: Using Make Commands

1. Clone the repository: `git clone https://github.com/cldcvr/codepipes-tutorials.git`

2. Navigate to the root directory of the app: `cd apps/04-golang-pgsql`

3. Build the app using make command: `make build`

4. Start the app using make command: `make run`

5. Open a browser and go to `http://localhost:3000` to use the app.

## Environment Variables

In order to connect to the Postgres server, the app needs the following environment variables:

- `DB_PASSWORD`: The password for the Postgres database
- `DB_HOST`: The host where the Postgres database is running. By default, it is set to `db`.
- `DB_USER`: The username for the Postgres database. By default, it is set to `postgres`.
- `DB_NAME`: The name of the Postgres database. By default, it is set to `postgres`.
- `DB_PORT`: The port number of the Postgres database. By default, it is set to `5432`.
- `DB_SSLMODE`: The SSL mode for the Postgres database. By default, it is set to `disable`.

Make sure to set these environment variables before running the app. You can set them using a `.env` file or by exporting them in the terminal.

## License

This app is licensed under the MIT License. See the LICENSE file for details.
