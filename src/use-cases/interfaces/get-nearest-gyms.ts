import { IGymEntity, LocationEntity } from "../../entities";
import { IUseCase } from "../types";

export interface IGetNearestGymsUseCase extends IUseCase {
  execute(
    location: LocationEntity,
    distance: number,
    amount?: number
  ): Promise<IGymEntity[]>;
}
