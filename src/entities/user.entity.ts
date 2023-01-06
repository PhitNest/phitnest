export interface IUserEntity {
  _id: string;
  cognitoId: string;
  gymId: string;
  email: string;
  firstName: string;
  lastName: string;
}

export type IRegisteredUser = IUserEntity & { confirmed: boolean };

export type IPublicUserEntity = Omit<IUserEntity, "email">;

export type IExploreUserEntity = Omit<IPublicUserEntity, "gymId">;

export type IProfilePictureUserEntity = IUserEntity & {
  profilePicture: string;
};

export type IProfilePicturePublicUserEntity = IPublicUserEntity & {
  profilePicture: string;
};

export type IProfilePictureExploreUserEntity = IExploreUserEntity & {
  profilePicture: string;
};
