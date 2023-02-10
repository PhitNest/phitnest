import { Failure } from "../../common/types";
import databases from "../../data/data-sources/injection";

export async function confirmRegister(email: string, code: string) {
  const user = await databases().userDatabase.getByEmail(email);
  if (user instanceof Failure) {
    return user;
  } else {
    const profilePictureUrl =
      await databases().profilePictureDatabase.getProfilePictureUrl(
        user.cognitoId
      );
    if (profilePictureUrl instanceof Failure) {
      return profilePictureUrl;
    } else {
      const session = await databases().authDatabase.confirmRegister(
        email,
        code
      );
      if (session instanceof Failure) {
        return session;
      } else {
        const result = await databases().userDatabase.setConfirmed(
          user.cognitoId
        );
        if (result instanceof Failure) {
          return result;
        } else {
          return {
            ...user,
            confirmed: true,
            profilePictureUrl: profilePictureUrl,
          };
        }
      }
    }
  }
}
