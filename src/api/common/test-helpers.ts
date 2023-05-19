import {
  DynamoDBClient,
  PutItemCommand,
  QueryCommand,
  QueryCommandInput,
} from "@aws-sdk/client-dynamodb";
import {
  APIGatewayEvent,
  APIGatewayProxyEventPathParameters,
  APIGatewayProxyEventQueryStringParameters,
  APIGatewayProxyEventMultiValueHeaders,
} from "aws-lambda";
import { MetadataBearer } from "@aws-sdk/types";
import { AwsStub, mockClient } from "aws-sdk-client-mock";

let dynamoMock: AwsStub<object, MetadataBearer>;

export function setupDynamoMock() {
  dynamoMock = mockClient(DynamoDBClient);
  dynamoMock.on(PutItemCommand).resolves({});
}

export function mockDynamoQuery(input: QueryCommandInput, response: any) {
  dynamoMock.on(QueryCommand, input).resolves(response);
}

export function clearDynamoMock() {
  dynamoMock.reset();
}

/**
 * This is required for spying on functions that are imported from other files
 */
export function setupMocks() {
  jest.mock("uuid", () => ({
    __esModule: true,
    ...jest.requireActual("uuid"),
  }));
}

function mockHttp(
  body?: any,
  pathParams?: APIGatewayProxyEventPathParameters,
  queryParams?: APIGatewayProxyEventQueryStringParameters,
  headers?: APIGatewayProxyEventMultiValueHeaders
): APIGatewayEvent {
  return {
    httpMethod: "",
    body: body ? JSON.stringify(body) : null,
    path: "",
    headers: { "Content-Type": "application/json", ...headers },
    pathParameters: pathParams ?? null,
    queryStringParameters: queryParams ?? null,
    multiValueHeaders: {} as APIGatewayProxyEventMultiValueHeaders,
    multiValueQueryStringParameters: null,
    isBase64Encoded: false,
    stageVariables: null,
    requestContext: {
      authorizer: null,
      identity: {
        cognitoIdentityPoolId: null,
        accountId: null,
        cognitoIdentityId: null,
        caller: null,
        sourceIp: "",
        principalOrgId: null,
        accessKey: null,
        cognitoAuthenticationType: null,
        cognitoAuthenticationProvider: null,
        userArn: null,
        userAgent: null,
        user: null,
        apiKey: null,
        apiKeyId: null,
        clientCert: null,
      },
      accountId: "developer",
      apiId: "",
      path: "",
      protocol: "",
      httpMethod: "",
      stage: "",
      requestId: "",
      requestTime: "",
      requestTimeEpoch: 0,
      resourceId: "",
      resourcePath: "",
    },
    resource: "",
  };
}

export function mockPost(
  body: any,
  pathParams?: APIGatewayProxyEventPathParameters
) {
  return mockHttp(body, pathParams, {});
}

export function mockPut(
  body: any,
  pathParams?: APIGatewayProxyEventPathParameters
) {
  return mockHttp(body, pathParams, {});
}

export function mockGet(
  pathParams?: APIGatewayProxyEventPathParameters,
  queryParams?: APIGatewayProxyEventQueryStringParameters
) {
  return mockHttp(undefined, pathParams, queryParams);
}

export function mockDelete(
  pathParams?: APIGatewayProxyEventPathParameters,
  queryParams?: APIGatewayProxyEventQueryStringParameters
) {
  return mockHttp(undefined, pathParams, queryParams);
}
