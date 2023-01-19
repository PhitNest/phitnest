import { Failure } from "../../src/common/types";
import { IProfilePictureDatabase } from "../../src/data/data-sources/databases/interfaces";

export const kMockProfilePictureError = new Failure(
  "MockProfilePictureError",
  "Mock profile picture error"
);

export class MockProfilePictureDatabase implements IProfilePictureDatabase {
  failingId: string;

  constructor(failingId: string) {
    this.failingId = failingId;
  }

  async getProfilePictureUploadUrl(userCognitoId: string) {
    if (userCognitoId === this.failingId) {
      return kMockProfilePictureError;
    } else {
      return "upload";
    }
  }

  async validateProfilePicture(userCognitoId: string) {
    if (userCognitoId === this.failingId) {
      return kMockProfilePictureError;
    }
  }

  async getProfilePictureUrl(userCognitoId: string) {
    if (userCognitoId === this.failingId) {
      return kMockProfilePictureError;
    } else {
      return "get";
    }
  }
}
