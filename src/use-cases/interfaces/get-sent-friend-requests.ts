import { IPublicUserEntity } from "../../entities";
import { IUseCase } from "../types";

export interface IGetSentFriendRequestsUseCase extends IUseCase {
  execute: (cognitoId: string) => Promise<IPublicUserEntity[]>;
}
