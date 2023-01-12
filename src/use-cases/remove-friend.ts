import { Failure } from "../common/types";
import repositories from "../repositories/injection";

export async function removeFriend(
  senderCognitoId: string,
  recipientCognitoId: string
) {
  const { friendshipRepo, friendRequestRepo } = repositories();
  const [deletion] = await Promise.all([
    friendshipRepo.delete([senderCognitoId, recipientCognitoId]),
    friendRequestRepo.create(recipientCognitoId, senderCognitoId),
  ]);
  if (deletion instanceof Failure) {
    return deletion;
  }
}
