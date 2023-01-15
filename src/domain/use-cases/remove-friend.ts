import { Failure } from "../../common/types";
import { friendshipRepo, friendRequestRepo } from "../repositories";

export async function removeFriend(
  senderCognitoId: string,
  recipientCognitoId: string
) {
  const [deletion] = await Promise.all([
    friendshipRepo.delete([senderCognitoId, recipientCognitoId]),
    friendRequestRepo.create(recipientCognitoId, senderCognitoId),
  ]);
  if (deletion instanceof Failure) {
    return deletion;
  }
}
