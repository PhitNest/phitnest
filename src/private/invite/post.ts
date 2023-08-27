import { APIGatewayEvent, APIGatewayProxyResult } from "aws-lambda";
import { z } from "zod";
import {
  RequestError,
  ResourceNotFoundError,
  Success,
  dynamo,
  getUserClaims,
  validateRequest,
} from "common/utils";
import { inviteToDynamo, kUserParser } from "common/entities";

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
      const client = dynamo();
      const user = await client.parsedQuery({
        pk: `USER#${userClaims.sub}`,
        sk: { q: "GYM#", op: "BEGINS_WITH" },
        limit: 1,
        parseShape: kUserParser,
      });
      if (user instanceof ResourceNotFoundError) {
        return user;
      } else if (user.numInvites > 0) {
        await client.writeTransaction({
          updates: [
            {
              pk: `USER#${userClaims.sub}`,
              sk: `GYM#${user.invite.gymId}`,
              expression: "SET numInvites = numInvites - 1",
              varMap: {},
            },
          ],
          puts: [
            {
              pk: `USER#${userClaims.sub}`,
              sk: `INVITE#${data.receiverEmail}`,
              data: inviteToDynamo({
                type: "user",
                receiverEmail: data.receiverEmail,
                senderId: userClaims.sub,
                createdAt: new Date(),
                gymId: user.invite.gymId,
              }),
            },
          ],
        });
        return new Success();
      } else {
        return new RequestError("NoInvites", "No invites available");
      }
    },
  });
}
