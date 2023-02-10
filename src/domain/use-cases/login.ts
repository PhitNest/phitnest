import { Failure } from "../../common/types";
import databases from "../../data/data-sources/injection";

export async function login(email: string, password: string) {
  const [session, user] = await Promise.all([
    databases().authDatabase.login(email, password),
    databases().userDatabase.getByEmail(email),
  ]);
  if (session instanceof Failure) {
    return session;
  } else {
    if (user instanceof Failure) {
      return user;
    } else {
      const [profilePictureUrl, gym] = await Promise.all([
        databases().profilePictureDatabase.getProfilePictureUrl(user.cognitoId),
        databases().gymDatabase.get(user.gymId),
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
