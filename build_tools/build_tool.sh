#!/bin/bash

set -e

cd "$(dirname "$0")/.."

export SAM_CLI_TELEMETRY=0
export SAM_CLI_BETA_ESBUILD=1

DGRAPH_NAME=DGraph
DGRAPH_PORT=8080
DGRAPH_HTTP_PORT=$((DGRAPH_PORT + 1000))
DGRAPH_GRPC_PORT=$((DGRAPH_PORT - 80))
DGRAPH_TEST_PORT=3080
DGRAPH_TEST_HTTP_PORT=$((DGRAPH_TEST_PORT + 1000))
DGRAPH_TEST_GRPC_PORT=$((DGRAPH_TEST_PORT - 80))

# Get platform-specific information
if [[ "$(uname)" == "Linux" ]]; then
    OPEN="xdg-open"
    DEFAULT_DGRAPH_DIR="/dgraph/data"
    DEFAULT_TEST_DGRAPH_DIR="/dgraph-test/data"
    SAM_CMD="sam"
else
    OPEN="bash start"
    DEFAULT_DGRAPH_DIR="C:/dgraph/data"
    DEFAULT_TEST_DGRAPH_DIR="C:/dgraph-test/data"
    SAM_CMD="sam.cmd"
fi

DGRAPH_DATA_DIR=${DEFAULT_DGRAPH_DIR}
DGRAPH_TEST_DIR=${DEFAULT_TEST_DGRAPH_DIR}
DGRAPH_STARTUP_TIMEOUT=15

function install() {
    npm i
    copy_modules
    gen_schema
    docker pull dgraph/standalone:latest
}

function run() {
    setup_run
    $SAM_CMD local start-api --parameter-overrides Stage=sandbox -t .aws-sam/build/template.yml
}

function debug() {
    setup_run
    $SAM_CMD local start-api --parameter-overrides Stage=sandbox -t .aws-sam/build/template.yml -d 5858
}

function test() {
    gen_schema
    dgraph_test $1
    echo "Waiting for DGraph to start..."
    sleep ${DGRAPH_STARTUP_TIMEOUT}

    # Set a trap to call stop_dgraph_test when the script exits or is interrupted
    trap "stop_dgraph_test $1" EXIT

    NODE_ENV=test npm run test

    # Explicitly call stop_dgraph_test and remove the trap
    trap - EXIT
    stop_dgraph_test $1
}

function deploy() {
    build_prod
    $SAM_CMD package --template-file .aws-sam/build/.aws-sam/build/template.yaml --s3-bucket phitnest-api-sam-prod --output-template-file .aws-sam/prod-out.yaml
    $SAM_CMD deploy --template-file .aws-sam/prod-out.yaml --s3-bucket phitnest-api-sam-prod --stack-name phitnest-api-prod --capabilities CAPABILITY_NAMED_IAM --no-fail-on-empty-changeset --parameter-overrides Stage=Prod Username=sam-cli
}

function dev_deploy() {
    build_dev
    $SAM_CMD package --template-file .aws-sam/build/.aws-sam/build/template.yaml --s3-bucket phitnest-api-sam-dev --output-template-file .aws-sam/dev-out.yaml
    $SAM_CMD deploy --template-file .aws-sam/dev-out.yaml --s3-bucket phitnest-api-sam-dev --stack-name phitnest-api-dev --capabilities CAPABILITY_NAMED_IAM --no-fail-on-empty-changeset --parameter-overrides Stage=Dev Username=sam-cli
}

function dgraph() {
    docker run -d -p ${DGRAPH_PORT}:8080 -p ${DGRAPH_HTTP_PORT}:9080 -p ${DGRAPH_GRPC_PORT}:8000 --mount type=bind,source=${DGRAPH_DATA_DIR},target=/dgraph --rm --name DGraph dgraph/standalone:latest
}

function stop_dgraph() {
    docker stop ${DGRAPH_NAME}
}

function dgraph_test() {
    DGRAPH_TEST_DIR=${1:-$DEFAULT_TEST_DGRAPH_DIR}
    docker run -d -p ${DGRAPH_TEST_PORT}:8080 -p ${DGRAPH_TEST_HTTP_PORT}:9080 -p ${DGRAPH_TEST_GRPC_PORT}:8000 --mount type=bind,source=${DGRAPH_TEST_DIR},target=/dgraph --rm --name DGraph-Test dgraph/standalone:latest
}

function stop_dgraph_test() {
    export DGRAPH_NAME=DGraph-Test
    DGRAPH_TEST_DIR=${1:-$DEFAULT_TEST_DGRAPH_DIR}
    stop_dgraph
    rm -rf ${DGRAPH_TEST_DIR}
}

function clean() {
    rm -rf .aws-sam schema.gql template.yml node_modules src/generated test package-lock.json
}

function commit_schema_local() {
    curl -X POST -H "Content-Type: application/graphql" --data-binary '@schema.gql' http://localhost:${DGRAPH_PORT}/admin/schema
}

function gen_schema() {
    schemaOutput="./schema.gql"
    schemaDir="./dgraph/schema/"

    while IFS= read -r file; do
    filename=$(basename "$file")
    if [[ "${filename#*.}" == "gql" ]]; then
        contents=$(cat "$file")
        schema="$schema$contents\n"
    fi
    done < <(find "$schemaDir" -type f)

    echo -e "$schema" > "$schemaOutput"
    npx graphql-code-generator --config ./codegen.ts
    sed -i 's/__typename?/__typename/g' ./src/generated/dgraph-schema.ts
}

function copy_modules() {
    mkdir -p .aws-sam/build
    cp package.json .aws-sam/build
    cp package-lock.json .aws-sam/build
    cd .aws-sam/build
    npm i
    cd ../..
}

function build_prod() {
    gen_schema
    ./build_tools/template_gen.sh prod
    NODE_ENV=production npm run build
    $SAM_CMD build -t .aws-sam/build/template.yml -b .aws-sam/build/.aws-sam/build
}

function build_dev() {
    gen_schema
    ./build_tools/template_gen.sh dev
    NODE_ENV=production npm run build
    $SAM_CMD build -t .aws-sam/build/template.yml -b .aws-sam/build/.aws-sam/build
}

function build_sandbox() {
    gen_schema
    ./build_tools/template_gen.sh dev
    NODE_ENV=development npm run build
}

function setup_run() {
    build_sandbox
    commit_schema_local
    ${OPEN} https://play.dgraph.io
}

function help() {
    echo "    phitnest-api install...............Installs the necessary dependencies and pulls the latest Docker image of the DGraph database."
    echo ""
    echo "    phitnest-api run...................Runs the server locally using the AWS SAM CLI."
    echo ""
    echo "    phitnest-api debug.................Runs the server locally in debug mode using the AWS SAM CLI."
    echo ""
    echo "    phitnest-api test..................Runs tests against the server using a test database."
    echo ""
    echo "    phitnest-api deploy................Builds the server and deploys it to the production environment."
    echo ""
    echo "    phitnest-api dev-deploy............Builds the server and deploys it to the development environment."
    echo ""
    echo "    phitnest-api dgraph................Starts a DGraph database instance on your local machine."
    echo ""
    echo "    phitnest-api stop-dgraph...........Stops the DGraph database instance that is running on your local machine."
    echo ""
    echo "    phitnest-api dgraph-test...........Starts a test DGraph database instance on your local machine."
    echo ""
    echo "    phitnest-api stop-dgraph-test......Stops the test DGraph database instance that is running on your local machine."
    echo ""
    echo "    phitnest-api clean.................Cleans the project by removing generated files."
}

case $1 in
    install)
        install
        ;;
    run)
        run
        ;;
    debug)
        debug
        ;;
    test)
        test $2
        ;;
    deploy)
        deploy
        ;;
    dev-deploy)
        dev_deploy
        ;;
    dgraph)
        dgraph
        ;;
    stop-dgraph)
        stop_dgraph
        ;;
    dgraph-test)
        dgraph_test
        ;;
    stop-dgraph-test)
        stop_dgraph_test
        ;;
    clean)
        clean
        ;;
    *)
        help
        ;;
esac
