import { Either } from "typescript-monads";
import { kFriendshipNotFound } from "../../common/failures";
import { IFriendshipEntity } from "../../entities";

export interface IFriendshipRepository {
  create(userCognitoIds: [string, string]): Promise<IFriendshipEntity>;

  deleteAll(): Promise<void>;

  get(cognitoId: string): Promise<IFriendshipEntity[]>;

  getByUsers(
    userCognitoIds: [string, string]
  ): Promise<Either<typeof kFriendshipNotFound, IFriendshipEntity>>;

  delete(
    userCognitoIds: [string, string]
  ): Promise<void | typeof kFriendshipNotFound>;
}
