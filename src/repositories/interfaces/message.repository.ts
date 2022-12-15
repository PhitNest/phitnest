import { IMessageEntity } from "../../entities";

export interface IMessageRepository {
  create(message: Omit<IMessageEntity, "_id">): Promise<IMessageEntity>;
}
