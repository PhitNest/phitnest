#!make
export SAM_CLI_TELEMETRY=0

## Build webpack for prod
webpack-build-prod:
	NODE_ENV=production npm run build

## Build webpack for local sandbox
webpack-build-sandbox:
	NODE_ENV=development npm run build

## Deploy application code (template.yml) to aws environment
deploy: webpack-build-prod
	sam package --template-file .aws-sam/build/template.yaml --s3-bucket phitnest-api-sam-prod --output-template-file build/templates/prod-out.yaml
	sam deploy --template-file build/templates/prod-out.yaml --s3-bucket phitnest-api-sam-prod --stack-name phitnest-api-prod --capabilities CAPABILITY_NAMED_IAM --no-fail-on-empty-changeset --parameter-overrides Stage=Prod Username=sam-cli

## Deploy application code (template.yml) to dev aws environment
dev-deploy: webpack-build-prod
	sam package --template-file .aws-sam/build/template.yaml --s3-bucket phitnest-api-sam-dev --output-template-file build/templates/dev-out.yaml
	sam deploy --template-file build/templates/dev-out.yaml --s3-bucket phitnest-api-sam-dev --stack-name phitnest-api-dev --capabilities CAPABILITY_NAMED_IAM --no-fail-on-empty-changeset --parameter-overrides Stage=Dev Username=sam-cli

## Run the lambda functions locally
run: webpack-build-sandbox
	sed -n 's/#USERNAME#/sam-cli/g' configs/lambdas-env.json
	cd .aws-sam/build/
	sam local start-api --env-vars configs/lambdas-env.json --parameter-overrides Stage=sandbox