import { kUserAlreadyConfirmed } from "../../common/failures";
import { Failure } from "../../common/types";
import databases from "../../data/data-sources/injection";

export async function unauthorizedProfilePictureUploadUrl(email: string) {
  const user = await databases().userDatabase.getByEmail(email);
  if (user instanceof Failure) {
    return user;
  } else if (user.confirmed) {
    return kUserAlreadyConfirmed;
  } else {
    const url =
      await databases().profilePictureDatabase.getProfilePictureUploadUrl(
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
}
