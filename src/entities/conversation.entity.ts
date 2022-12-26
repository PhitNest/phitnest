import { IPublicUserEntity } from "./user.entity";

export interface IConversationEntity {
  _id: string;
  users: string[];
}

export interface IPopulatedConversationEntity {
  _id: string;
  users: IPublicUserEntity[];
}
