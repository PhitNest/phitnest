import { Failure } from "../../../../common/types";

export interface IProfilePictureDatabase {
  getProfilePictureUploadUrl(userCognitoId: string): Promise<string | Failure>;

  getProfilePictureUrl(userCognitoId: string): Promise<string | Failure>;
}
