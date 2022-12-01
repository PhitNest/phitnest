import { IAuthEntity } from "../../entities";
import { IUseCase } from "../types";

export interface ILoginUseCase extends IUseCase {
  execute: (email: string, password: string) => Promise<IAuthEntity>;
}
