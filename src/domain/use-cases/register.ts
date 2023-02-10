import { kGymNotFound } from "../../common/failures";
import { Failure } from "../../common/types";
import databases from "../../data/data-sources/injection";

export async function registerUser(user: {
  email: string;
  firstName: string;
  lastName: string;
  gymId: string;
  password: string;
}) {
  const gym = await databases().gymDatabase.get(user.gymId);
  if (gym instanceof Failure) {
    return kGymNotFound;
  } else {
    return databases()
      .authDatabase.registerUser(user.email, user.password)
      .then(async (cognitoRegistration) => {
        if (cognitoRegistration instanceof Failure) {
          return cognitoRegistration;
        } else {
          const profilePictureUrl =
            await databases().profilePictureDatabase.getProfilePictureUploadUrl(
              cognitoRegistration
            );
          if (profilePictureUrl instanceof Failure) {
            return profilePictureUrl;
          } else {
            return {
              user: await databases().userDatabase.create({
                ...user,
                cognitoId: cognitoRegistration,
              }),
              uploadUrl: profilePictureUrl,
            };
          }
        }
      });
  }
}
