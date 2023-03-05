#!make
export SAM_CLI_TELEMETRY=0

S3_BUCKET = phitnest-api-sam-cli

.SILENT:
.PHONY: help

## Prints this help screen
help:
	printf "Available targets\n\n"
	awk '/^[a-zA-Z\-0-9]+:/ { \
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
	sam package --template-file .aws-sam/build/template.yaml --s3-bucket $(S3_BUCKET) --output-template-file build/templates/prod-out.yaml
	sam deploy --template-file build/templates/prod-out.yaml --s3-bucket $(S3_BUCKET) --stack-name phitnest-api --capabilities CAPABILITY_NAMED_IAM --no-fail-on-empty-changeset --parameter-overrides Stage=prod Username=sam-cli

## Run the lambda functions locally
run: webpack-build
	sed -n 's/#USERNAME#/sam-cli/g' configs/lambdas-env.json
	cd .aws-sam/build/
	sam local start-api --env-vars configs/lambdas-env.json
	
## Display logs of certain function (ex: make logs function=FUNCTION-NAME)
logs:
	sam logs -n $(function) --stack-name phitnest-api