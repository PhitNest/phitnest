import { Either } from "typescript-monads";
import { kUserNotFound } from "../../common/failures";
import { ICognitoUser, IUserEntity } from "../../entities";

export interface IUserRepository {
  create(user: ICognitoUser): Promise<IUserEntity>;

  delete(cognitoId: string): Promise<void | typeof kUserNotFound>;

  setConfirmed(cognitoId: string): Promise<void | typeof kUserNotFound>;

  getByEmail(email: string): Promise<Either<typeof kUserNotFound, IUserEntity>>;

  get(cognitoId: string): Promise<Either<typeof kUserNotFound, IUserEntity>>;

  haveSameGym(cognitoId1: string, cognitoId2: string): Promise<boolean>;

  deleteAll(): Promise<void>;
}
