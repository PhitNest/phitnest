import { Failure } from "../../../common/types";
import {
  ICognitoUser,
  IPublicUserEntity,
  IUserEntity,
} from "../../../domain/entities";

export interface IUserDatabase {
  create(user: ICognitoUser): Promise<IUserEntity>;

  delete(cognitoId: string): Promise<void | Failure>;

  setConfirmed(cognitoId: string): Promise<void | Failure>;

  getByEmail(email: string): Promise<IUserEntity | Failure>;

  get(cognitoId: string): Promise<IUserEntity | Failure>;

  getByGym(gymId: string): Promise<IPublicUserEntity[]>;

  haveSameGym(cognitoId1: string, cognitoId2: string): Promise<boolean>;

  deleteAll(): Promise<void>;
}
