#!make
export SAM_CLI_TELEMETRY=0
.PHONY: dgraph

clean:
	npm run clean

commit-schema:
	curl -X POST -H "Content-Type: application/graphql" --data-binary '@schema.gql' http://localhost:8080/admin/schema

gen-schema:
	scripts/gen_combined_schema.sh
	npx graphql-code-generator --config ./codegen.ts

test: gen-schema
	scripts/template_gen.sh dev
	make dgraph-test
	make commit-schema
	NODE_ENV=development DGRAPH_PORT=3080 npm run test
	make stop-dgraph-test

webpack-build-prod: gen-schema
	scripts/template_gen.sh prod
	NODE_ENV=production npm run build

webpack-build-dev: gen-schema
	scripts/template_gen.sh dev
	NODE_ENV=production npm run build

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
	make commit-schema
	sed -n 's/#USERNAME#/sam-cli/g' lambdas-env.json
	cd .aws-sam/build/
	sam local start-api --env-vars lambdas-env.json --parameter-overrides Stage=sandbox

# Get the platform specific open command
ifeq ($(OS),Windows_NT)
    OPEN := bash start
else
    UNAME := $(shell uname -s)
    ifeq ($(UNAME),Linux)
        OPEN := xdg-open
    endif
endif

stop-dgraph:
	docker stop DGraph

dgraph:
	$(OPEN) https://play.dgraph.io
	docker run -d -p 8080:8080 -p 9080:9080 -p 8000:8000 --mount type=bind,source=C:/dgraph/data,target=/dgraph --rm --name DGraph dgraph/standalone:latest

dgraph-test:
	docker run -d -p 3080:8080 -p 4080:9080 -p 3000:8000 --mount type=bind,source=C:/dgraph-test/data,target=/dgraph --rm --name DGraph-Test dgraph/standalone:latest
	
stop-dgraph-test:
	rm -Rf C:/dgraph-test
	docker stop DGraph-Test

## Installs all dependencies
install:
	npm ci
	npm i -g webpack
	make gen-schema
	docker pull dgraph/standalone:latest
