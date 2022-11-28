import { IUseCase } from "../types";

export interface IRegisterUseCase extends IUseCase {
  execute: (
    email: string,
    password: string,
    gymId: string,
    firstName: string,
    lastName: string
  ) => Promise<void>;
}
