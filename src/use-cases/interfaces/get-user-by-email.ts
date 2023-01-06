import { IUserEntity, IRegisteredUser } from "../../entities";
import { IUseCase } from "../types";

export interface IGetUserByEmailUseCase extends IUseCase {
  execute(email: string): Promise<IRegisteredUser>;
}
