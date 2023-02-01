import { Failure } from "../../common/types";
import { authRepo, profilePictureRepo, userRepo } from "../repositories";

export async function login(email: string, password: string) {
  const session = await authRepo.login(email, password);
  if (session instanceof Failure) {
    return session;
  } else {
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
        return {
          ...session,
          user: {
            ...user,
            profilePictureUrl: profilePictureUrl,
          },
        };
      }
    }
  }
}
