import { IUseCase } from "../types";

export interface IBlockUseCase extends IUseCase {
  execute(senderId: string, recipientId: string): Promise<void>;
}
