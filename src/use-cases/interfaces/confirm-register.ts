import { IUseCase } from "../types";

export interface IConfirmRegisterUseCase extends IUseCase {
  execute: (email: string, code: string) => Promise<void>;
}
