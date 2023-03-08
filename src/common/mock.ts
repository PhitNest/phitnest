import {
  APIGatewayEvent,
  APIGatewayProxyEventPathParameters,
  APIGatewayProxyEventQueryStringParameters,
  APIGatewayProxyEventMultiValueHeaders,
  Context,
} from "aws-lambda";
import mockContext from "aws-lambda-mock-context";

function mockHttp(
  body?: any,
  pathParams?: APIGatewayProxyEventPathParameters,
  queryParams?: APIGatewayProxyEventQueryStringParameters,
  headers?: APIGatewayProxyEventMultiValueHeaders
): [APIGatewayEvent, Context] {
  return [
    {
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
    },
    mockContext(),
  ];
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
