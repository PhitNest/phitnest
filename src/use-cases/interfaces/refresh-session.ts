import { IAuthEntity } from "../../entities";
import { IUseCase } from "../types";

export interface IRefreshSessionUseCase extends IUseCase {
  execute: (
    refreshToken: string,
    email: string
  ) => Promise<Omit<IAuthEntity, "refreshToken">>;
}
