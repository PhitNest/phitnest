import { Failure } from "../../common/types";
import { ICognitoUser, IUserEntity } from "../../entities";

export interface IUserRepository {
  create(user: ICognitoUser): Promise<IUserEntity>;

  delete(cognitoId: string): Promise<void | Failure>;

  setConfirmed(cognitoId: string): Promise<void | Failure>;

  getByEmail(email: string): Promise<IUserEntity | Failure>;

  get(cognitoId: string): Promise<IUserEntity | Failure>;

  haveSameGym(cognitoId1: string, cognitoId2: string): Promise<boolean>;

  deleteAll(): Promise<void>;
}
