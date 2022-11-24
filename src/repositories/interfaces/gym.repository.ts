import { IGymEntity, ILocationEntity } from "../../entities";

export interface IGymRepository {
  getNearest(
    location: ILocationEntity,
    distance: number,
    amount: number
  ): Promise<IGymEntity[]>;

  get(userId: string): Promise<IGymEntity>;
}
