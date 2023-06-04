import { dynamo, err, handleRequest } from "api/common/utils";
import { kUserWithoutInviteDynamo } from "api/common/entities";
import { APIGatewayEvent, APIGatewayProxyResult } from "aws-lambda";

export async function invoke(
  event: APIGatewayEvent
): Promise<APIGatewayProxyResult> {
  return handleRequest(async () => {
    const userId = event.requestContext.authorizer?.claims.sub;
    if (!userId) {
      err("Unauthenticated");
    }
    const client = dynamo().connect();
    return {
      statusCode: 200,
      body: JSON.stringify(
        await client.parsedQuery({
          pk: "USERS",
          sk: { q: `USER#${userId}`, op: "EQ" },
          parseShape: kUserWithoutInviteDynamo,
        })
      ),
    };
  });
}
