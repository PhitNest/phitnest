import { IUseCase } from "../types";

export interface ISendFriendRequestUseCase extends IUseCase {
  execute: (senderId: string, recipientId: string) => Promise<void>;
}
