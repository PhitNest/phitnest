import { IUserRepository } from "../../adapters/repositories/interfaces";
import { IGymEntity } from "../entities";

export type GetGymUseCase = (userId: string) => Promise<IGymEntity>;

export function buildGetGymUseCase(
  userRepository: IUserRepository
): GetGymUseCase {
  return function (userId) {
    return userRepository.getGym(userId);
  };
}
