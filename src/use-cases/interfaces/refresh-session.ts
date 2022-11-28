import { IUseCase } from "../types";

export interface IRefreshSessionUseCase extends IUseCase {
  execute: (refreshToken: string, cognitoId: string) => Promise<string>;
}
