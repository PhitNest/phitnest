import {
  APIGatewayEvent,
  APIGatewayProxyEventPathParameters,
  APIGatewayProxyEventQueryStringParameters,
  APIGatewayProxyEventMultiValueHeaders,
} from "aws-lambda";

function mockHttp(
  type: string,
  body?: any,
  pathParams?: APIGatewayProxyEventPathParameters,
  queryParams?: APIGatewayProxyEventQueryStringParameters,
  headers?: APIGatewayProxyEventMultiValueHeaders
): APIGatewayEvent {
  return {
    httpMethod: type,
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
  return mockHttp("POST", body, pathParams, {});
}

export function mockPut(
  body: any,
  pathParams?: APIGatewayProxyEventPathParameters
) {
  return mockHttp("PUT", body, pathParams, {});
}

export function mockGet(
  pathParams?: APIGatewayProxyEventPathParameters,
  queryParams?: APIGatewayProxyEventQueryStringParameters
) {
  return mockHttp("GET", undefined, pathParams, queryParams);
}

export function mockDelete(
  pathParams?: APIGatewayProxyEventPathParameters,
  queryParams?: APIGatewayProxyEventQueryStringParameters
) {
  return mockHttp("DELETE", undefined, pathParams, queryParams);
}
