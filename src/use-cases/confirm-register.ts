import { Failure } from "../common/types";
import repositories from "../repositories/injection";

export async function confirmRegister(email: string, code: string) {
  const { authRepo, userRepo, profilePictureRepo } = repositories();
  const user = await userRepo.getByEmail(email);
  if (user instanceof Failure) {
    return user;
  } else {
    const profilePictureUrl = await profilePictureRepo.getProfilePictureUrl(
      user.cognitoId
    );
    if (profilePictureUrl instanceof Failure) {
      return profilePictureUrl;
    } else {
      const session = await authRepo.confirmRegister(email, code);
      if (session instanceof Failure) {
        return session;
      } else {
        const result = await userRepo.setConfirmed(user.cognitoId);
        if (result instanceof Failure) {
          return result;
        } else {
          user.confirmed = true;
          return {
            ...user,
            profilePictureUrl: profilePictureUrl,
          };
        }
      }
    }
  }
}
