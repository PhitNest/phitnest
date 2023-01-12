import { kGymNotFound } from "../common/failures";
import { Failure } from "../common/types";
import repositories from "../repositories/injection";

export async function registerUser(user: {
  email: string;
  firstName: string;
  lastName: string;
  gymId: string;
  password: string;
}) {
  const { authRepo, userRepo, gymRepo } = repositories();
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
          return userRepo.create({
            ...user,
            cognitoId: cognitoRegistration,
          });
        }
      });
  }
}
