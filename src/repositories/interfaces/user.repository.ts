import { IPublicUserEntity, IUserEntity } from "../../entities";

export interface IUserRepository {
  create(
    cognitoId: string,
    email: string,
    gymId: string,
    firstName: string,
    lastName: string
  ): Promise<IUserEntity>;
  delete(cognitoId: string): Promise<void>;
  exploreUsers(
    cognitoId: string,
    offset?: number,
    limit?: number
  ): Promise<Omit<IPublicUserEntity, "gymId">[]>;
  get(cognitoId: string): Promise<IUserEntity | null>;
}
