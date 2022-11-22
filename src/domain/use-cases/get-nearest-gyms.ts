import { IGymRepository } from "../../adapters/repositories/interfaces";
import { IGymEntity, ILocationEntity } from "../entities";

export type GetNearestGymsUseCase = (
  location: ILocationEntity,
  distance: number,
  amount: number
) => Promise<IGymEntity[]>;

export function buildGetNearestGymsUseCase(
  gymRepository: IGymRepository
): GetNearestGymsUseCase {
  return function (location, distance, amount) {
    return gymRepository.getNearestGyms(location, distance, amount);
  };
}
