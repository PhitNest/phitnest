import { IUseCase } from "../types";

export interface IDenyFriendRequestUseCase extends IUseCase {
  execute: (senderId: string, recipientId: string) => Promise<void>;
}
