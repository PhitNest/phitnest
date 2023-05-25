import { handleRequest } from "api/common/utils";
import { APIGatewayProxyResult } from "aws-lambda";

export async function invoke(): Promise<APIGatewayProxyResult> {
  return await handleRequest(async () => {
    const {
      USER_POOL_ID,
      USER_POOL_CLIENT_ID,
      ADMIN_POOL_ID,
      ADMIN_POOL_CLIENT_ID,
    } = process.env;
    if (
      USER_POOL_ID &&
      USER_POOL_CLIENT_ID &&
      ADMIN_POOL_ID &&
      ADMIN_POOL_CLIENT_ID
    ) {
      return {
        statusCode: 200,
        body: JSON.stringify({
          userPoolId: USER_POOL_ID,
          userClientId: USER_POOL_CLIENT_ID,
          adminPoolId: ADMIN_POOL_ID,
          adminClientId: ADMIN_POOL_CLIENT_ID,
        }),
      };
    } else {
      return {
        statusCode: 200,
        body: "sandbox",
        headers: {
          "Content-Type": "text/plain",
        },
      };
    }
  });
}
