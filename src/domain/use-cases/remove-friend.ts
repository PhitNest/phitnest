import { Failure } from "../../common/types";
import databases from "../../data/data-sources/injection";

export async function removeFriend(
  senderCognitoId: string,
  recipientCognitoId: string
) {
  const [deletion] = await Promise.all([
    databases().friendshipDatabase.delete([
      senderCognitoId,
      recipientCognitoId,
    ]),
    databases().friendRequestDatabase.create(
      recipientCognitoId,
      senderCognitoId
    ),
  ]);
  if (deletion instanceof Failure) {
    return deletion;
  }
}
