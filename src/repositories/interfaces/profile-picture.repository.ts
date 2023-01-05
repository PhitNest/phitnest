export interface IProfilePictureRepository {
  getProfilePictureUrl(userCognitoId: string): Promise<string>;

  getPresignedUploadURL(userCognitoId: string): Promise<string>;
}
