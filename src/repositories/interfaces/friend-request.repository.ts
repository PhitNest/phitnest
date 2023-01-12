import { Failure } from "../../common/types";
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
  ): Promise<IFriendRequestEntity | Failure>;

  deny(fromCognitoId: string, toCognitoId: string): Promise<void | Failure>;

  delete(fromCognitoId: string, toCognitoId: string): Promise<void | Failure>;

  deleteAll(): Promise<void>;
}
