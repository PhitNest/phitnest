import { IUserEntity } from "../../entities";
import { IUseCase } from "../types";

export interface IGetUserUseCase extends IUseCase {
  execute: (cognitoId: string) => Promise<IUserEntity | null>;
}
