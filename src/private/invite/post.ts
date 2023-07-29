import { APIGatewayEvent, APIGatewayProxyResult } from "aws-lambda";
import { z } from "zod";
import {
  ResourceNotFoundError,
  Success,
  dynamo,
  getUserClaims,
  kUserNotFound,
  validateRequest,
} from "common/utils";
import {
  kUserWithPartialInviteParser,
  userInviteToDynamo,
} from "common/entities";

const validator = z.object({
  receiverEmail: z.string().email(),
});

export async function invoke(
  event: APIGatewayEvent
): Promise<APIGatewayProxyResult> {
  return validateRequest({
    data: JSON.parse(event.body ?? "{}"),
    validator: validator,
    controller: async (data) => {
      const userClaims = getUserClaims(event);
      const client = dynamo().connect();
      const user = await client.parsedQuery({
        pk: "USERS",
        sk: { q: `USER#${userClaims.sub}`, op: "EQ" },
        parseShape: kUserWithPartialInviteParser,
      });
      if (user instanceof ResourceNotFoundError) {
        return kUserNotFound;
      } else {
        await client.put({
          pk: `INVITE#${userClaims.email}`,
          sk: `RECEIVER#${data.receiverEmail}`,
          data: userInviteToDynamo({
            type: "user",
            receiverEmail: data.receiverEmail,
            inviter: user,
            createdAt: new Date(),
            gym: user.invite.gym,
          }),
        });
        return new Success();
      }
    },
  });
}
