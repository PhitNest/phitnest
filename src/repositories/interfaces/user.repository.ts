import mongoose from "mongoose";
import { IUserEntity } from "../../entities";

export interface IUserRepository {
  create(
    cognitoId: string,
    email: string,
    gymId: mongoose.Types.ObjectId,
    firstName: string,
    lastName: string
  ): Promise<IUserEntity>;
  delete(cognitoId: string): Promise<void>;
  exploreUsers(
    cognitoId: string,
    offset?: number,
    limit?: number
  ): Promise<Omit<IUserEntity, "email" | "gymId">[]>;
  get(cognitoId: string): Promise<IUserEntity | null>;
}
