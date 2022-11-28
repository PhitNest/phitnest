import { IUseCase } from "../types";

export interface IForgotPasswordUseCase extends IUseCase {
  execute: (email: string) => Promise<void>;
}
