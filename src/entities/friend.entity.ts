import { IUserEntity } from "./user.entity";

export interface IFriendEntity extends Omit<IUserEntity, "email"> {
  since: Date;
}
