#!make
export SAM_CLI_TELEMETRY=0
.PHONY: dgraph

DGRAPH_NAME ?= DGraph
DGRAPH_PORT ?= 8080
DGRAPH_HTTP_PORT := $(shell expr $(DGRAPH_PORT) + 1000)
DGRAPH_GRPC_PORT := $(shell expr $(DGRAPH_PORT) - 80)

DGRAPH_DATA_DIR ?= $(DGRAPH_DIR)

DGRAPH_STARTUP_TIMEOUT ?= 30

# Remove all non-version controlled files
clean:
	npm run clean

# Commit GraphQL schema to DGraph instance running on localhost
commit-schema-local:
	curl -X POST -H "Content-Type: application/graphql" --data-binary '@schema.gql' http://localhost:$(DGRAPH_PORT)/admin/schema

# Combine the GraphQL schema files into one file and generate the TypeScript types
gen-schema:
	scripts/gen_combined_schema.sh
	npx graphql-code-generator --config ./codegen.ts

# Run the tests
test: gen-schema
	make dgraph DGRAPH_PORT=3080 DGRAPH_DATA_DIR=$(TEST_DGRAPH_DIR) DGRAPH_NAME=DGraph-Test
	sleep $(DGRAPH_STARTUP_TIMEOUT)
	- make commit-schema-local DGRAPH_PORT=3080
	- NODE_ENV=test npm run test
	- rm -Rf $(TEST_DGRAPH_DIR)
	make stop-dgraph DGRAPH_NAME=DGraph-Test

# Build the application for production
webpack-build-prod: gen-schema
	scripts/template_gen.sh prod
	NODE_ENV=production npm run build

# Build the application for development environment on AWS
webpack-build-dev: gen-schema
	scripts/template_gen.sh dev
	NODE_ENV=production npm run build

# Build the application for local development
webpack-build-sandbox: gen-schema
	scripts/template_gen.sh dev
	NODE_ENV=development npm run build

## Deploy application code (template.yml) to aws environment
deploy: webpack-build-prod
	sam package --template-file .aws-sam/build/template.yaml --s3-bucket phitnest-api-sam-prod --output-template-file build/templates/prod-out.yaml
	sam deploy --template-file build/templates/prod-out.yaml --s3-bucket phitnest-api-sam-prod --stack-name phitnest-api-prod --capabilities CAPABILITY_NAMED_IAM --no-fail-on-empty-changeset --parameter-overrides Stage=Prod Username=sam-cli

## Deploy application code (template.yml) to dev aws environment
dev-deploy: webpack-build-dev
	sam package --template-file .aws-sam/build/template.yaml --s3-bucket phitnest-api-sam-dev --output-template-file build/templates/dev-out.yaml
	sam deploy --template-file build/templates/dev-out.yaml --s3-bucket phitnest-api-sam-dev --stack-name phitnest-api-dev --capabilities CAPABILITY_NAMED_IAM --no-fail-on-empty-changeset --parameter-overrides Stage=Dev Username=sam-cli

## Run the lambda functions locally
run: webpack-build-sandbox
	make commit-schema-local
	sed -n 's/#USERNAME#/sam-cli/g' lambdas-env.json
	cd .aws-sam/build/
	$(OPEN) https://play.dgraph.io
	sam local start-api --env-vars lambdas-env.json --parameter-overrides Stage=sandbox

# Get the platform specific information
ifeq ($(OS),Windows_NT)
    OPEN := bash start
	TEST_DGRAPH_DIR := C:/dgraph-test/data
	DGRAPH_DIR := C:/dgraph/data
else
    UNAME := $(shell uname -s)
    ifeq ($(UNAME),Linux)
        OPEN := xdg-open
		TEST_DGRAPH_DIR := /dgraph-test/data
		DGRAPH_DIR := /dgraph/data
    endif
endif

# Stop DGraph instance
stop-dgraph:
	docker stop $(DGRAPH_NAME)

# Start DGraph instance
dgraph:
	docker run -d -p $(DGRAPH_PORT):8080 -p $(DGRAPH_HTTP_PORT):9080 -p $(DGRAPH_GRPC_PORT):8000 --mount type=bind,source=$(DGRAPH_DATA_DIR),target=/dgraph --rm --name $(DGRAPH_NAME) dgraph/standalone:latest

## Installs all dependencies
install:
	npm i
	npm i -g webpack
	make gen-schema
	docker pull dgraph/standalone:latest
