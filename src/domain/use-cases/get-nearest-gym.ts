import { IGymRepository } from "../../adapters/repositories/interfaces";
import { IGymEntity, ILocationEntity } from "../entities";

export type GetNearestGymUseCase = (
  location: ILocationEntity,
  distance: number
) => Promise<IGymEntity>;

export function buildGetNearestGymUseCase(
  gymRepository: IGymRepository
): GetNearestGymUseCase {
  return function (location, distance) {
    return gymRepository.getNearestGym(location, distance);
  };
}
