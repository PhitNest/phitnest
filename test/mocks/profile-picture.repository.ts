import { injectable } from "inversify";
import { IProfilePictureRepository } from "../../src/repositories/interfaces";

@injectable()
export class MockProfilePictureRepo implements IProfilePictureRepository {
  async getPresignedGetURL(cognitoId: string) {
    return `https://example.com/${cognitoId}`;
  }

  async getPresignedUploadURL(cognitoId: string) {
    return `https://example.com/${cognitoId}`;
  }

  async hasProfilePicture(userCognitoId: string) {
    return true;
  }
}
