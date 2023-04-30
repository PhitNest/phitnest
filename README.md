# PhitNest SAM REST API

Serverless REST API running with Node.js and AWS SAM framework.

### Prerequisites

* [NodeJS version 16 or later](https://nodejs.org/en/download/) - or use [nvm](https://github.com/nvm-sh/nvm)
* [SAM CLI](https://aws.amazon.com/serverless/sam/)
* [Docker](https://www.docker.com/)

### VSCode Extensions

You should use the following VSCode extensions:

* [GraphQL](https://marketplace.visualstudio.com/items?itemName=mquandalle.graphql)
* [Prettier ESLint](https://marketplace.visualstudio.com/items?itemName=rvest.vs-code-prettier-eslint)

### Install Dependencies

To install the dependencies, you should run the following command:
```
phitnest api install                            # If you have the CLI installed and in your path

./build_tools/build_tool.sh install             # If you do not have the CLI installed
```

### Run locally

To run the REST API locally for development, you should run the following command:
```
phitnest api run                                # If you have the CLI installed and in your path

./build_tools/build_tool.sh run                 # If you do not have the CLI installed
```

#### Debug Mode

To debug the REST API locally, you should run the following command:
```
phitnest api debug                              # If you have the CLI installed and in your path

./build_tools/build_tool.sh debug               # If you do not have the CLI installed
```

This will bind the debugger to port 5858. You can then run the `Attach to SAM CLI` launch configuration in VSCode to
start the debug process.

### Run Tests

To run the tests, you should run the following command:
```
phitnest api test                               # If you have the CLI installed and in your path

./build_tools/build_tool.sh test                # If you do not have the CLI installed
```

#### Debug Mode

To debug the tests, you should first start a DGraph test server locally. To do this, you should run the following command:
```
phitnest api dgraph-test                        # If you have the CLI installed and in your path

./build_tools/build_tool.sh dgraph-test         # If you do not have the CLI installed
```

This will start a DGraph database server on port 3080. You can then run the tests in debug mode by using the `Debug Tests` launch configuration in VSCode.

To stop the DGraph test server, you should run the following command:
```
phitnest api dgraph-test-stop                   # If you have the CLI installed and in your path

./build_tools/build_tool.sh dgraph-test-stop    # If you do not have the CLI installed
```
