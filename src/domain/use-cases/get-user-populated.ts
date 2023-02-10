import { Failure } from "../../common/types";
import databases from "../../data/data-sources/injection";

export async function getUserPopulated(cognitoId: string) {
  const [user, profilePictureUrl] = await Promise.all([
    databases().userDatabase.get(cognitoId),
    databases().profilePictureDatabase.getProfilePictureUrl(cognitoId),
  ]);
  if (user instanceof Failure) {
    return user;
  } else if (profilePictureUrl instanceof Failure) {
    return profilePictureUrl;
  } else {
    const gym = await databases().gymDatabase.get(user.gymId);
    if (gym instanceof Failure) {
      return gym;
    } else {
      return {
        ...user,
        profilePictureUrl: profilePictureUrl,
        gym: gym,
      };
    }
  }
}
