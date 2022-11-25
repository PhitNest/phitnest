import { IUseCase } from "../types";

export interface IAuthenticateUseCase extends IUseCase {
  execute(accessToken: string): Promise<string | null>;
}
