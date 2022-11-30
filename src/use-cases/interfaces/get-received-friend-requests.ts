import { IPublicUserEntity } from "../../entities";
import { IUseCase } from "../types";

export interface IGetReceivedFriendRequestsUseCase extends IUseCase {
  execute: (cognitoId: string) => Promise<IPublicUserEntity[]>;
}
