import { kUserNotConfirmed } from "../../common/failures";
import { Failure } from "../../common/types";
import { authRepo, userRepo } from "../repositories";

export async function forgotPassword(email: string) {
  const user = await userRepo.getByEmail(email);
  if (user instanceof Failure) {
    return user;
  } else {
    if (user.confirmed) {
      return authRepo.forgotPassword(email);
    } else {
      return kUserNotConfirmed;
    }
  }
}
