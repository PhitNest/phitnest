import { Failure } from "../../common/types";
import { userRepo, gymRepo, profilePictureRepo } from "../repositories";

export async function getUserPopulated(cognitoId: string) {
  const [user, profilePictureUrl] = await Promise.all([
    userRepo.get(cognitoId),
    profilePictureRepo.getProfilePictureUrl(cognitoId),
  ]);
  if (user instanceof Failure) {
    return user;
  } else if (profilePictureUrl instanceof Failure) {
    return profilePictureUrl;
  } else {
    const gym = await gymRepo.get(user.gymId);
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
