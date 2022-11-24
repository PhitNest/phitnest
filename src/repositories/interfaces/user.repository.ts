import { IUserEntity } from "../../entities";

export interface IUserRepository {
  create(user: IUserEntity): Promise<boolean>;
  delete(userId: string): Promise<void>;
  exploreUsers(
    userId: string,
    offset?: number,
    limit?: number
  ): Promise<Partial<IUserEntity>[]>;
}
