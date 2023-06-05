import { dynamo, validateRequest, Success } from "api/common/utils";
import { kUserWithoutInviteDynamo } from "api/common/entities";
import { APIGatewayEvent, APIGatewayProxyResult } from "aws-lambda";
import { z } from "zod";

const validator = z.object({
  userId: z.string(),
});

export async function invoke(
  event: APIGatewayEvent
): Promise<APIGatewayProxyResult> {
  return validateRequest({
    data: { userId: event.requestContext.authorizer?.claims.sub },
    validator: validator,
    controller: async (data) => {
      const client = dynamo().connect();
      return new Success(
        await client.parsedQuery({
          pk: "USERS",
          sk: { q: `USER#${data.userId}`, op: "EQ" },
          parseShape: kUserWithoutInviteDynamo,
        })
      );
    },
  });
}
