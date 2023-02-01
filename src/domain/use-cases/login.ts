import { Failure } from "../../common/types";
import {
  authRepo,
  gymRepo,
  profilePictureRepo,
  userRepo,
} from "../repositories";

export async function login(email: string, password: string) {
  const [session, user] = await Promise.all([
    authRepo.login(email, password),
    userRepo.getByEmail(email),
  ]);
  if (session instanceof Failure) {
    return session;
  } else {
    if (user instanceof Failure) {
      return user;
    } else {
      const [profilePictureUrl, gym] = await Promise.all([
        profilePictureRepo.getProfilePictureUrl(user.cognitoId),
        gymRepo.get(user.gymId),
      ]);
      if (profilePictureUrl instanceof Failure) {
        return profilePictureUrl;
      } else if (gym instanceof Failure) {
        return gym;
      } else {
        return {
          ...session,
          gym: gym,
          user: {
            ...user,
            profilePictureUrl: profilePictureUrl,
          },
        };
      }
    }
  }
}
