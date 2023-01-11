import { IPublicUserEntity } from "./user.entity";

export interface IFriendshipEntity {
  _id: string;
  userCognitoIds: [string, string];
  createdAt: Date;
}

export type IPopulatedFriendshipEntity = IFriendshipEntity & {
  users: [IPublicUserEntity, IPublicUserEntity];
};
