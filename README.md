# PhitNest SAM REST API

Serverless REST API running with Node.js and AWS SAM framework.

### Prerequisites

* [NodeJS version 16 or later](https://nodejs.org/en/download/) - or use [nvm](https://github.com/nvm-sh/nvm)
* [SAM CLI](https://aws.amazon.com/serverless/sam/)
* [Docker](https://www.docker.com/)

### Install Dependencies
```
make install
```

### Local Development

Run DGraph
```
make dgraph
```

Emulates the backend locally
```
make run
```
When this command runs successfully, you will see the endpoints you can invoke

Stops DGraph
```
make stop-dgraph
```

Runs tests
```
make test
```