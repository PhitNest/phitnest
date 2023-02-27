import { Failure } from "../../common/types";
import databases from "../../data/data-sources/injection";

export async function removeFriend(
  senderCognitoId: string,
  recipientCognitoId: string
) {
  const deletion = await databases().friendshipDatabase.delete([
    senderCognitoId,
    recipientCognitoId,
  ]);
  if (deletion instanceof Failure) {
    return deletion;
  } else {
    const creation = await databases().friendRequestDatabase.create(
      recipientCognitoId,
      senderCognitoId
    );
    if (creation instanceof Failure) {
      return creation;
    }
  }
}
