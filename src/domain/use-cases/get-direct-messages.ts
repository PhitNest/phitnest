import { Failure } from "../../common/types";
import databases from "../../data/data-sources/injection";

export async function getDirectMessages(users: [string, string]) {
  const friendship = await databases().friendshipDatabase.getByUsers(users);
  if (friendship instanceof Failure) {
    return friendship;
  } else {
    return databases().directMessageDatabase.get(friendship._id);
  }
}
