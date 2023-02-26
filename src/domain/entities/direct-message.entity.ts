import { IPublicUserEntity } from "./user.entity";

export interface IDirectMessageEntity {
  _id: string;
  text: string;
  senderCognitoId: string;
  friendshipId: string;
  createdAt: Date;
}

export type IPopulatedDirectMessageEntity = IDirectMessageEntity & {
  sender: IPublicUserEntity;
  recipient: IPublicUserEntity;
};
