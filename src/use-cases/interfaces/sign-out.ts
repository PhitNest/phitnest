import { IUseCase } from "../types";

export interface ISignOutUseCase extends IUseCase {
  execute: (cognitoId: string, allDevices: boolean) => Promise<void>;
}
