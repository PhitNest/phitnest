import { IFriendEntity } from "../../entities";
import { IUseCase } from "../types";

export interface IGetFriendsUseCase extends IUseCase {
  execute: (cognitoId: string) => Promise<IFriendEntity[]>;
}
