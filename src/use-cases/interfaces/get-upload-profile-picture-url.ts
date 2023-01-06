import { IUseCase } from "../types";

export interface IGetUploadProfilePictureURLUseCase extends IUseCase {
  execute: (cognitoId: string) => Promise<string>;
}
