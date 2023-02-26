import { IPublicUserEntity } from "./user.entity";

export interface IFriendRequestEntity {
  _id: string;
  fromCognitoId: string;
  toCognitoId: string;
  denied: boolean;
  createdAt: Date;
}

export type IPopulatedFriendRequestEntity = IFriendRequestEntity & {
  fromUser: IPublicUserEntity;
  toUser: IPublicUserEntity;
};
