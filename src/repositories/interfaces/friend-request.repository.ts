import { Either } from "typescript-monads";
import { kFriendRequestNotFound } from "../../common/failures";
import { IFriendRequestEntity } from "../../entities";

export interface IFriendRequestRepository {
  create(
    fromCognitoId: string,
    toCognitoId: string
  ): Promise<IFriendRequestEntity>;

  getByFromCognitoId(fromCognitoId: string): Promise<IFriendRequestEntity[]>;

  getByToCognitoId(toCognitoId: string): Promise<IFriendRequestEntity[]>;

  getByCognitoIds(
    fromCognitoId: string,
    toCognitoId: string
  ): Promise<Either<IFriendRequestEntity, typeof kFriendRequestNotFound>>;

  delete(
    fromCognitoId: string,
    toCognitoId: string
  ): Promise<void | typeof kFriendRequestNotFound>;

  deleteAll(): Promise<void>;
}
