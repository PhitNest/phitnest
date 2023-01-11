export interface IUserEntity {
  _id: string;
  cognitoId: string;
  gymId: string;
  email: string;
  firstName: string;
  lastName: string;
  confirmed: boolean;
}

export type ICognitoUser = Omit<IUserEntity, "_id" | "confirmed">;

export type IPublicUserEntity = Omit<IUserEntity, "email">;

export type IFriendEntity = IPublicUserEntity & {
  since: Date;
};

export type IExploreUserEntity = Omit<IPublicUserEntity, "gymId">;

type IProfilePictureEntity<UserType> = UserType & {
  profilePicture: string;
};

export type IProfilePictureUserEntity = IProfilePictureEntity<IUserEntity>;

export type IProfilePicturePublicUserEntity =
  IProfilePictureEntity<IPublicUserEntity>;

export type IProfilePictureExploreUserEntity =
  IProfilePictureEntity<IExploreUserEntity>;
