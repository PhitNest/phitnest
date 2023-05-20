import { handleRequest } from "api/common/utils";
import { APIGatewayProxyResult } from "aws-lambda";

export async function invoke(): Promise<APIGatewayProxyResult> {
  return await handleRequest(async () => {
    const { userPoolId, userClientId, adminPoolId, adminClientId } =
      process.env;
    if (userPoolId && userClientId && adminPoolId && adminClientId) {
      return {
        statusCode: 200,
        body: JSON.stringify({
          userPoolId: userPoolId,
          userClientId: userClientId,
          adminPoolId: adminPoolId,
          adminClientId: adminClientId,
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
