import { Failure } from "../../common/types";
import { directMessageRepo, friendshipRepo } from "../repositories";

export async function getDirectMessages(users: [string, string]) {
  const friendship = await friendshipRepo.getByUsers(users);
  if (friendship instanceof Failure) {
    return friendship;
  } else {
    return directMessageRepo.get(friendship._id);
  }
}
