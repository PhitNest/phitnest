import { IUseCase } from "../types";

export interface IResendConfirmationUseCase extends IUseCase {
  execute: (email: string) => Promise<void>;
}
