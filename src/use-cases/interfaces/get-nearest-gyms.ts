import { IGymEntity, ILocationEntity } from "../../entities";
import { IUseCase } from "../types";

export interface IGetNearestGymsUseCase extends IUseCase {
  execute(
    location: ILocationEntity,
    distance: number,
    amount: number
  ): Promise<IGymEntity[]>;
}
