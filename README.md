# PhitNest SAM REST API

Serverless REST API running with Node.js and AWS SAM framework.

### Prerequisites

* [NodeJS version 16 or later](https://nodejs.org/en/download/) - or use [nvm](https://github.com/nvm-sh/nvm)
* [AWS Command Line Interface](https://docs.aws.amazon.com/cli/latest/userguide/installing.html)
* [SAM CLI](https://aws.amazon.com/serverless/sam/)

### Local Development
To invoke the function locally through API Gateway
```
make run
```
When this command runs successfully, you will see the endpoints you can invoke

## Make targets
```
help            Prints this help screen
install         Install npm dependencies
deploy          Deploy application code (template.yml) to aws environment
run             Run the lambda functions locally
logs            Display logs of certain function (ex: make logs function=FUNCTION-NAME)
```