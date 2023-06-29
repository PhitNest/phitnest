import { APIGatewayEvent, APIGatewayProxyResult } from "aws-lambda";
import { z } from "zod";
import {
  Success,
  dynamo,
  getUserClaims,
  validateRequest,
} from "api/common/utils";
import {
  inviteToDynamo,
  kUserWithPartialInviteDynamo,
} from "api/common/entities";

const validator = z.object({
  userEmail: z.string(),
  userId: z.string(),
  receiverEmail: z.string().email(),
});

export async function invoke(
  event: APIGatewayEvent
): Promise<APIGatewayProxyResult> {
  return validateRequest({
    data: {
      ...JSON.parse(event.body ?? "{}"),
      userEmail: getUserClaims(event)?.email,
      userId: getUserClaims(event)?.sub,
    },
    validator: validator,
    controller: async (data) => {
      const client = dynamo().connect();
      const user = await client.parsedQuery({
        pk: "USERS",
        sk: { q: `USER#${data.userId}`, op: "EQ" },
        parseShape: kUserWithPartialInviteDynamo,
      });
      await client.put({
        pk: `INVITE#${data.userEmail}`,
        sk: `RECEIVER#${data.receiverEmail}`,
        data: inviteToDynamo({
          type: "user",
          receiverEmail: data.receiverEmail,
          inviter: user,
          createdAt: new Date(),
          gym: user.invite.gym,
        }),
      });
      return new Success();
    },
  });
}
