import { Failure } from "../../common/types";
import databases from "../../data/data-sources/injection";

export async function sendDirectMessage(
  senderCognitoId: string,
  recipientCognitoId: string,
  text: string
) {
  const friendship = await databases().friendshipDatabase.getByUsers([
    senderCognitoId,
    recipientCognitoId,
  ]);
  if (friendship instanceof Failure) {
    return friendship;
  } else {
    return databases().directMessageDatabase.create({
      friendshipId: friendship._id,
      text: text,
      senderCognitoId: senderCognitoId,
    });
  }
}
