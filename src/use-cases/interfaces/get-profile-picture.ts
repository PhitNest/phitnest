import { IUseCase } from "../types";

export interface IGetProfilePictureUseCase extends IUseCase {
  execute: (cognitoId: string) => Promise<string>;
}
