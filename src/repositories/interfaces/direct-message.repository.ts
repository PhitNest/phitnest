import { IDirectMessageEntity } from "../../entities";

export interface IDirectMessageRepository {
  create(
    message: Omit<IDirectMessageEntity, "_id">
  ): Promise<IDirectMessageEntity>;
}
