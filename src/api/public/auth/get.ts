import { handleRequest, environmentVars, err } from "api/common/utils";
import { APIGatewayProxyResult } from "aws-lambda";

export async function invoke(): Promise<APIGatewayProxyResult> {
  return await handleRequest(async () => {
    const {
      USER_POOL_ID,
      USER_POOL_CLIENT_ID,
      ADMIN_POOL_ID,
      ADMIN_POOL_CLIENT_ID,
      SANDBOX_MODE,
    } = environmentVars;
    if (SANDBOX_MODE === "sandbox") {
      return {
        statusCode: 200,
        body: "sandbox",
        headers: {
          "Content-Type": "text/plain",
        },
      };
    } else {
      if (!ADMIN_POOL_CLIENT_ID) {
        err("Unable to find admin pool client id");
      }
      if (!ADMIN_POOL_ID) {
        err("Unable to find admin pool id");
      }
      if (!USER_POOL_CLIENT_ID) {
        err("Unable to find user pool client id");
      }
      if (!USER_POOL_ID) {
        err("Unable to find user pool id");
      }
      return {
        statusCode: 200,
        body: JSON.stringify({
          userPoolId: USER_POOL_ID,
          userClientId: USER_POOL_CLIENT_ID,
          adminPoolId: ADMIN_POOL_ID,
          adminClientId: ADMIN_POOL_CLIENT_ID,
        }),
      };
    }
  });
}
