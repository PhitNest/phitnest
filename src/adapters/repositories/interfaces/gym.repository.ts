import { IGymEntity, ILocationEntity } from "../../../domain/entities";

export interface IGymRepository {
  getNearestGym(
    location: ILocationEntity,
    distance: number
  ): Promise<IGymEntity>;
}
