import { Failure } from "../common/types";
import repositories from "../repositories/injection";

export async function getUserPopulated(cognitoId: string) {
  const { userRepo, gymRepo } = repositories();
  const user = await userRepo.get(cognitoId);
  if (user instanceof Failure) {
    return user;
  } else {
    const gym = await gymRepo.get(user.gymId);
    if (gym instanceof Failure) {
      return gym;
    } else {
      return {
        ...user,
        gym: gym,
      };
    }
  }
}
