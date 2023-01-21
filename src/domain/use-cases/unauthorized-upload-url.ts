import {
  kUserAlreadyConfirmed,
  kUserNotConfirmed,
} from "../../common/failures";
import { Failure } from "../../common/types";
import { authRepo, userRepo, profilePictureRepo } from "../repositories";

export async function unauthorizedProfilePictureUploadUrl(
  email: string,
  password: string
) {
  const result = await authRepo.login(email, password);
  if (result instanceof Failure) {
    if (result.code === kUserNotConfirmed.code) {
      const user = await userRepo.getByEmail(email);
      if (user instanceof Failure) {
        return user;
      } else {
        const url = await profilePictureRepo.getProfilePictureUploadUrl(
          user.cognitoId
        );
        if (url instanceof Failure) {
          return url;
        } else {
          return {
            url: url,
          };
        }
      }
    } else {
      return result;
    }
  } else {
    return kUserAlreadyConfirmed;
  }
}
