import { Failure } from "../../common/types";

export interface IProfilePictureRepository {
  getProfilePictureUploadUrl(userCognitoId: string): Promise<string | Failure>;

  getProfilePictureUrl(userCognitoId: string): Promise<string | Failure>;
}
