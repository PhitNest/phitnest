import { Failure } from "../../common/types";
import { IFriendshipEntity } from "../../entities";

export interface IFriendshipRepository {
  create(userCognitoIds: [string, string]): Promise<IFriendshipEntity>;

  deleteAll(): Promise<void>;

  get(cognitoId: string): Promise<IFriendshipEntity[]>;

  getByUsers(
    userCognitoIds: [string, string]
  ): Promise<IFriendshipEntity | Failure>;

  delete(userCognitoIds: [string, string]): Promise<void | Failure>;
}
