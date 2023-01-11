import { kDirectMessageNotFound } from "../../common/failures";
import { IDirectMessageEntity } from "../../entities";

export interface IDirectMessageRepository {
  create(
    message: Omit<IDirectMessageEntity, "_id" | "createdAt">
  ): Promise<IDirectMessageEntity>;

  deleteAll(): Promise<void>;

  get(friendshipId: string, amount?: number): Promise<IDirectMessageEntity[]>;

  delete(messageId: string): Promise<void | typeof kDirectMessageNotFound>;
}
