import { IUseCase } from "../types";

export interface IForgotPasswordSubmitUseCase extends IUseCase {
  execute: (email: string, code: string, newPassword: string) => Promise<void>;
}
