import { kGymNotFound } from "../../common/failures";
import { Failure } from "../../common/types";
import {
  authRepo,
  userRepo,
  gymRepo,
  profilePictureRepo,
} from "../repositories";

export async function registerUser(user: {
  email: string;
  firstName: string;
  lastName: string;
  gymId: string;
  password: string;
}) {
  const gym = await gymRepo.get(user.gymId);
  if (gym instanceof Failure) {
    return kGymNotFound;
  } else {
    return authRepo
      .registerUser(user.email, user.password)
      .then(async (cognitoRegistration) => {
        if (cognitoRegistration instanceof Failure) {
          return cognitoRegistration;
        } else {
          const profilePictureUrl =
            await profilePictureRepo.getProfilePictureUploadUrl(
              cognitoRegistration
            );
          if (profilePictureUrl instanceof Failure) {
            return profilePictureUrl;
          } else {
            return {
              ...(await userRepo.create({
                ...user,
                cognitoId: cognitoRegistration,
              })),
              uploadUrl: profilePictureUrl,
            };
          }
        }
      });
  }
}