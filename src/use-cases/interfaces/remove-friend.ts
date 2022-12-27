import { IUseCase } from "../types";

export interface IRemoveFriendUseCase extends IUseCase {
  execute(cognitoId: string, friendId: string): Promise<void>;
}
