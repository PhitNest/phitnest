import { IUseCase } from "../types";

export interface IUnblockUseCase extends IUseCase {
  execute(senderId: string, recipientId: string): Promise<void>;
}
