import { Failure } from "../../common/types";
import { friendshipRepo, directMessageRepo } from "../repositories";

export async function sendDirectMessage(
  senderCognitoId: string,
  recipientCognitoId: string,
  text: string
) {
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
