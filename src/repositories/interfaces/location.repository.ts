import { Either } from "typescript-monads";
import { kLocationNotFound } from "../../common/failures";
import { IAddressEntity, LocationEntity } from "../../entities";

export interface ILocationRepository {
  get(
    address: IAddressEntity
  ): Promise<Either<LocationEntity, typeof kLocationNotFound>>;
}
