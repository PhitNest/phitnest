import {
  dynamo,
  validateRequest,
  Success,
  getUserClaims,
} from "api/common/utils";
import { kUserWithPartialInviteDynamo } from "api/common/entities";
import { APIGatewayEvent, APIGatewayProxyResult } from "aws-lambda";
import { z } from "zod";

const validator = z.object({
  userId: z.string(),
});

export async function invoke(
  event: APIGatewayEvent
): Promise<APIGatewayProxyResult> {
  return validateRequest({
    data: { userId: getUserClaims(event)?.sub },
    validator: validator,
    controller: async (data) => {
      const client = dynamo().connect();
      const user = await client.parsedQuery({
        pk: "USERS",
        sk: { q: `USER#${data.userId}`, op: "EQ" },
        parseShape: kUserWithPartialInviteDynamo,
      });
      return new Success(user);
    },
  });
}
