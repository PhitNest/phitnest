import dataSources from "../../data/data-sources/injection";

class ProfilePictureRepository {
  getProfilePictureUploadUrl(userCognitoId: string) {
    return dataSources().profilePictureDatabase.getProfilePictureUploadUrl(
      userCognitoId
    );
  }

  getProfilePictureUrl(userCognitoId: string) {
    return dataSources().profilePictureDatabase.getProfilePictureUrl(
      userCognitoId
    );
  }
}

export const profilePictureRepo = new ProfilePictureRepository();
