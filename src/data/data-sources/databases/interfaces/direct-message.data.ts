import { IDirectMessageEntity } from "../../../../domain/entities";

export interface IDirectMessageDatabase {
  create(
    message: Omit<IDirectMessageEntity, "_id" | "createdAt">
  ): Promise<IDirectMessageEntity>;

  deleteAll(): Promise<void>;

  get(friendshipId: string, amount?: number): Promise<IDirectMessageEntity[]>;
}
