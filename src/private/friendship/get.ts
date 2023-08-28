import { APIGatewayEvent, APIGatewayProxyResult } from "aws-lambda";
import { dynamo, Success, getUserClaims, handleRequest } from "common/utils";
import {
  getFriendshipsWithMessages,
  getReceivedFriendRequests,
} from "common/repository";

export async function invoke(
  event: APIGatewayEvent
): Promise<APIGatewayProxyResult> {
  return handleRequest(async () => {
    const userClaims = getUserClaims(event);
    const client = dynamo();
    const [friendships, receivedFriendRequests] = await Promise.all([
      getFriendshipsWithMessages(client, userClaims.sub),
      getReceivedFriendRequests(client, userClaims.sub),
    ]);
    return new Success({
      friendships: friendships,
      friendRequests: receivedFriendRequests,
    });
  });
}
