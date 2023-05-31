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
import { AdminCognitoClaims, UserCognitoClaims } from "./utils";

let dynamoMock: AwsStub<object, MetadataBearer>;

export function setupDynamoMock() {
  dynamoMock = mockClient(DynamoDBClient);
  dynamoMock.on(PutItemCommand).resolves({});
}

export function mockDynamoQuery(input: QueryCommandInput, response: object) {
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

type HttpParams = {
  headers?: APIGatewayProxyEventMultiValueHeaders;
};

type PostPutParams = HttpParams & {
  body?: object | string;
  pathParams?: APIGatewayProxyEventPathParameters;
  authClaims?: AdminCognitoClaims | UserCognitoClaims;
};

type GetDeleteParams = HttpParams & {
  pathParams?: APIGatewayProxyEventPathParameters;
  queryParams?: APIGatewayProxyEventQueryStringParameters;
  authClaims?: AdminCognitoClaims | UserCognitoClaims;
};

function mockHttp(params: PostPutParams & GetDeleteParams): APIGatewayEvent {
  return {
    httpMethod: "",
    body: params.body ? JSON.stringify(params.body) : null,
    path: "",
    headers: { "Content-Type": "application/json", ...params.headers },
    pathParameters: params.pathParams ?? null,
    queryStringParameters: params.queryParams ?? null,
    multiValueHeaders: {} as APIGatewayProxyEventMultiValueHeaders,
    multiValueQueryStringParameters: null,
    isBase64Encoded: false,
    stageVariables: null,
    requestContext: {
      authorizer: {
        claims: params.authClaims ?? null,
      },
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

export function mockPost(params: PostPutParams) {
  return mockHttp(params);
}

export function mockPut(params: PostPutParams) {
  return mockHttp(params);
}

export function mockGet(params: GetDeleteParams) {
  return mockHttp(params);
}

export function mockDelete(params: GetDeleteParams) {
  return mockHttp(params);
}
