#!make
include ./configs/.env
export $(shell sed 's/=.*//' ./configs/.env)
export SAM_CLI_TELEMETRY=0
export UID=$(shell id -u)
export GID=$(shell id -g)

S3_BUCKET = phitnest-api-sam-cli

.SILENT:
.PHONY: help

## Prints this help screen
help:
	printf "Available targets\n\n"
	awk '/^[a-zA-Z\-\_0-9]+:/ { \
		helpMessage = match(lastLine, /^## (.*)/); \
		if (helpMessage) { \
			helpCommand = substr($$1, 0, index($$1, ":")-1); \
			helpMessage = substr(lastLine, RSTART + 3, RLENGTH); \
			printf "%-15s %s\n", helpCommand, helpMessage; \
		} \
	} \
	{ lastLine = $$0 }' $(MAKEFILE_LIST)

## Build webpack
webpack-build:
	NODE_ENV=production npm run build

## Deploy application code (template.yml) to aws environment
deploy: webpack-build
	scripts/deploy.sh prod $(S3_BUCKET) phitnest-api "template" sam-cli

## Run the lambda functions locally
run: webpack-build
	cp configs/lambdas-env.json /tmp/lambdas-env.json && sed -n 's/#USERNAME#/sam-cli/g' /tmp/lambdas-env.json
	cd .aws-sam/build/ && sam.cmd local start-api --env-vars /tmp/lambdas-env.json 
	
#--profile prod

## Display logs of certain function (ex: make logs function=FUNCTION-NAME)
logs:
	sam.cmd logs -n $(function) --stack-name phitnest-api 
	
#--profile prod
