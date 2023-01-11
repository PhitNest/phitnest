import { Either } from "typescript-monads";
import { kUserNotFound } from "../../common/failures";
import { ICognitoUser, IUserEntity } from "../../entities";

export interface IUserRepository {
  create(user: ICognitoUser): Promise<IUserEntity>;

  delete(cognitoId: string): Promise<void | typeof kUserNotFound>;

  setConfirmed(cognitoId: string): Promise<void | typeof kUserNotFound>;

  getByEmail(email: string): Promise<Either<IUserEntity, typeof kUserNotFound>>;

  get(cognitoId: string): Promise<Either<IUserEntity, typeof kUserNotFound>>;

  haveSameGym(cognitoId1: string, cognitoId2: string): Promise<boolean>;

  deleteAll(): Promise<void>;
}
