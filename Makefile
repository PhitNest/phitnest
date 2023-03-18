#!make
export SAM_CLI_TELEMETRY=0

test:
	template/scripts/template_gen.sh dev
	NODE_ENV=development npm run test

## Build webpack for prod
webpack-build-prod:
	template/scripts/template_gen.sh prod
	NODE_ENV=production npm run build

## Build webpack for dev
webpack-build-dev:
	template/scripts/template_gen.sh dev
	NODE_ENV=production npm run build

## Build webpack for local sandbox
webpack-build-sandbox:
	template/scripts/template_gen.sh dev
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
	sed -n 's/#USERNAME#/sam-cli/g' configs/lambdas-env.json
	cd .aws-sam/build/
	sam local start-api --env-vars configs/lambdas-env.json --parameter-overrides Stage=sandbox

# Get the platform specific open command
ifeq ($(OS),Windows_NT)
    OPEN := bash start
else
    UNAME := $(shell uname -s)
    ifeq ($(UNAME),Linux)
        OPEN := xdg-open
    endif
endif

## Runs dgraph standalone locally
dgraph:
	$(OPEN) https://play.dgraph.io
	docker run -it -p 8080:8080 -p 9080:9080 -p 8000:8000 -v ~/dgraph:/dgraph dgraph/standalone:v20.03.0

## Installs all dependencies
install:
	npm ci
	npm i -g webpack
	docker pull dgraph/standalone:latest