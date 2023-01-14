import { Failure } from "../common/types";
import repositories from "../repositories/injection";

export async function sendDirectMessage(
  senderCognitoId: string,
  recipientCognitoId: string,
  text: string
) {
  const { friendshipRepo, directMessageRepo } = repositories();
  const friendship = await friendshipRepo.getByUsers([
    senderCognitoId,
    recipientCognitoId,
  ]);
  if (friendship instanceof Failure) {
    return friendship;
  } else {
    return directMessageRepo.create({
      friendshipId: friendship._id,
      text: text,
      senderCognitoId: senderCognitoId,
    });
  }
}
