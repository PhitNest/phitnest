export interface IProfilePictureRepository {
  getPresignedGetURL(userCognitoId: string): Promise<string>;

  getPresignedUploadURL(userCognitoId: string): Promise<string>;

  hasProfilePicture(userCognitoId: string): Promise<boolean>;
}
