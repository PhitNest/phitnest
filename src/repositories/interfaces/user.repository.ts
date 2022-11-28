import { IPublicUserEntity, IUserEntity } from "../../entities";

export interface IUserRepository {
  create(user: Omit<IUserEntity, "_id">): Promise<IUserEntity>;
  delete(cognitoId: string): Promise<boolean>;
  exploreUsers(
    cognitoId: string,
    offset?: number,
    limit?: number
  ): Promise<Omit<IPublicUserEntity, "gymId">[]>;
  get(cognitoId: string): Promise<IUserEntity | null>;
}
