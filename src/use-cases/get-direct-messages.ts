import { Failure } from "../common/types";
import repositories from "../repositories/injection";

export async function getDirectMessages(users: [string, string]) {
  const { directMessageRepo, friendshipRepo } = repositories();
  const friendship = await friendshipRepo.getByUsers(users);
  if (friendship instanceof Failure) {
    return friendship;
  } else {
    return directMessageRepo.get(friendship._id);
  }
}
