#!make
export SAM_CLI_TELEMETRY=0
.PHONY: dgraph

DGRAPH_NAME ?= DGraph
DGRAPH_PORT ?= 8080
DGRAPH_HTTP_PORT := $(shell expr $(DGRAPH_PORT) + 1000)
DGRAPH_GRPC_PORT := $(shell expr $(DGRAPH_PORT) - 80)

# Get the platform specific information
ifeq ($(OS),Windows_NT)
    OPEN := bash start
	DEFAULT_DGRAPH_DIR := C:/dgraph/data
	DEFAULT_TEST_DGRAPH_DIR := C:/dgraph-test/data
else
    UNAME := $(shell uname -s)
    ifeq ($(UNAME),Linux)
        OPEN := xdg-open
		DEFAULT_DGRAPH_DIR := /dgraph/data
		DEFAULT_TEST_DGRAPH_DIR := /dgraph-test/data
    endif
endif

DGRAPH_DATA_DIR ?= $(DEFAULT_DGRAPH_DIR)

DGRAPH_TEST_DIR ?= $(DEFAULT_TEST_DGRAPH_DIR)

DGRAPH_STARTUP_TIMEOUT ?= 15

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
	make dgraph-test
	sleep $(DGRAPH_STARTUP_TIMEOUT)
	- NODE_ENV=test npm run test
	make stop-dgraph-test

# Copies node_modules to .aws-sam/build/node_modules
copy-modules:
	mkdir -p .aws-sam/build
	cp package.json .aws-sam/build
	cp package-lock.json .aws-sam/build
	cd .aws-sam/build && npm i

# Build the application for production
build-prod: gen-schema
	scripts/template_gen.sh prod
	NODE_ENV=production npm run build

# Build the application for development environment on AWS
build-dev: gen-schema
	scripts/template_gen.sh dev
	NODE_ENV=production npm run build

# Build the application for local development
build-sandbox: gen-schema
	scripts/template_gen.sh dev
	NODE_ENV=development npm run build

## Deploy application code (template.yml) to aws environment
deploy: build-prod
	sam package --template-file .aws-sam/build/template.yaml --s3-bucket phitnest-api-sam-prod --output-template-file build/templates/prod-out.yaml
	sam deploy --template-file build/templates/prod-out.yaml --s3-bucket phitnest-api-sam-prod --stack-name phitnest-api-prod --capabilities CAPABILITY_NAMED_IAM --no-fail-on-empty-changeset --parameter-overrides Stage=Prod Username=sam-cli

## Deploy application code (template.yml) to dev aws environment
dev-deploy: build-dev
	sam package --template-file .aws-sam/build/template.yaml --s3-bucket phitnest-api-sam-dev --output-template-file build/templates/dev-out.yaml
	sam deploy --template-file build/templates/dev-out.yaml --s3-bucket phitnest-api-sam-dev --stack-name phitnest-api-dev --capabilities CAPABILITY_NAMED_IAM --no-fail-on-empty-changeset --parameter-overrides Stage=Dev Username=sam-cli

# Setup for run and debug
setup-run: build-sandbox
	make commit-schema-local
	cd .aws-sam/build/
	$(OPEN) https://play.dgraph.io

## Run the lambda functions locally
run: setup-run
	sam local start-api --parameter-overrides Stage=sandbox

## Debug the lambda functions locally
debug: setup-run
	sam local start-api --parameter-overrides Stage=sandbox -d 5858

# Stop DGraph instance
stop-dgraph:
	docker stop $(DGRAPH_NAME)

# Stop DGraph instance and remove test data directory
stop-dgraph-test:
	make stop-dgraph DGRAPH_NAME=DGraph-Test
	rm -Rf $(DGRAPH_TEST_DIR)

# Start DGraph instance for testing
dgraph-test:
	make dgraph DGRAPH_PORT=3080 DGRAPH_DATA_DIR=$(DGRAPH_TEST_DIR) DGRAPH_NAME=DGraph-Test

# Start DGraph instance
dgraph:
	docker run -d -p $(DGRAPH_PORT):8080 -p $(DGRAPH_HTTP_PORT):9080 -p $(DGRAPH_GRPC_PORT):8000 --mount type=bind,source=$(DGRAPH_DATA_DIR),target=/dgraph --rm --name $(DGRAPH_NAME) dgraph/standalone:latest

## Installs all dependencies
install:
	npm i
	make copy-modules
	make gen-schema
	docker pull dgraph/standalone:latest
