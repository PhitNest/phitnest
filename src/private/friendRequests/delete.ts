import {
  dynamo,
  validateRequest,
  Success,
  getUserClaims,
  CognitoClaimsError,
} from "common/utils";
import { APIGatewayEvent, APIGatewayProxyResult } from "aws-lambda";
import { z } from "zod";

const validator = z.object({
  friendId: z.string(),
});

export async function invoke(
  event: APIGatewayEvent
): Promise<APIGatewayProxyResult> {
  return validateRequest({
    data: JSON.parse(event.body ?? "{}"),
    validator: validator,
    controller: async (data) => {
      const userClaims = getUserClaims(event);
      if (userClaims instanceof CognitoClaimsError) {
        return userClaims;
      } else {
        const client = dynamo().connect();
        await client.writeTransaction({
          deletes: [
            {
              pk: `USER#${data.friendId}`,
              sk: `FRIEND_REQUEST#${userClaims.sub}`,
            },
            {
              pk: `INCOMING_REQUEST#${userClaims.sub}`,
              sk: `SENDER#${data.friendId}`,
            },
          ],
          puts: [],
          updates: [],
        });
        return new Success();
      }
    },
  });
}
