import { IMessageEntity } from "../../entities";

export interface IMessageRepository {
  create(message: Omit<IMessageEntity, "_id">): Promise<IMessageEntity>;

  get(
    conversationId: string,
    offset?: number,
    limit?: number
  ): Promise<IMessageEntity[]>;

  deleteAll(): Promise<void>;
}
