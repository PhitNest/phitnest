# PhitNest SAM REST API

Serverless REST API running with Node.js and AWS SAM framework.

### Prerequisites

* [NodeJS version 16 or later](https://nodejs.org/en/download/) - or use [nvm](https://github.com/nvm-sh/nvm)
* [SAM CLI](https://aws.amazon.com/serverless/sam/)
* [Docker](https://www.docker.com/)

### Install

First, pull this repository

Next, add this repository to your $PATH so you can easily call `phitnest-api` commands.

### CLI Commands

`phitnest-api install`

Installs the necessary dependencies and pulls the latest Docker image of the DGraph database.

`phitnest-api run`

Runs the server locally using the AWS SAM CLI.

`phitnest-api debug`

Runs the server locally in debug mode using the AWS SAM CLI.

`phitnest-api test`

Runs tests against the server using a test database.

`phitnest-api deploy`

Builds the server and deploys it to the production environment.

`phitnest-api dev-deploy`

Builds the server and deploys it to the development environment.

`phitnest-api dgraph`

Starts a DGraph database instance on your local machine.

`phitnest-api stop-dgraph`

Stops the DGraph database instance that is running on your local machine.

`phitnest-api dgraph-test`

Starts a test DGraph database instance on your local machine.

`phitnest-api stop-dgraph-test`

Stops the test DGraph database instance that is running on your local machine.

`phitnest-api clean`

Cleans the project by removing generated files.