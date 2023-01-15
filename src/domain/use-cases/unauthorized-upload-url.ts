import {
  kInvalidCognitoId,
  kUserAlreadyConfirmed,
} from "../../common/failures";
import { Failure } from "../../common/types";
import { userRepo, profilePictureRepo } from "../repositories";

export async function unauthorizedProfilePictureUploadUrl(
  email: string,
  cognitoId: string
) {
  const user = await userRepo.getByEmail(email);
  if (user instanceof Failure) {
    return user;
  } else {
    if (user.cognitoId === cognitoId) {
      if (user.confirmed) {
        return kUserAlreadyConfirmed;
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
      return kInvalidCognitoId;
    }
  }
}
