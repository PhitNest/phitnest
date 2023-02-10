import { kUserNotConfirmed } from "../../common/failures";
import { Failure } from "../../common/types";
import databases from "../../data/data-sources/injection";

export async function forgotPassword(email: string) {
  const user = await databases().userDatabase.getByEmail(email);
  if (user instanceof Failure) {
    return user;
  } else {
    if (user.confirmed) {
      return databases().authDatabase.forgotPassword(email);
    } else {
      return kUserNotConfirmed;
    }
  }
}
