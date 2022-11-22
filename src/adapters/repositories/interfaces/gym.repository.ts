import { IGymEntity, ILocationEntity } from "../../../domain/entities";

export interface IGymRepository {
  getNearestGyms(
    location: ILocationEntity,
    distance: number,
    amount: number
  ): Promise<IGymEntity[]>;
}
