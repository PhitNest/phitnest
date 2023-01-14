import { kDirectMessageNotFound } from "../../common/failures";
import { IDirectMessageEntity } from "../../entities";
import { DirectMessageModel } from "../../mongo";
import { IDirectMessageRepository } from "../interfaces";

export class MongoDirectMessageRepository implements IDirectMessageRepository {
  async create(message: Omit<IDirectMessageEntity, "_id" | "createdAt">) {
    return (await DirectMessageModel.create(message)).toObject();
  }

  async deleteAll() {
    await DirectMessageModel.deleteMany({});
  }

  async get(friendshipId: string, amount?: number) {
    if (amount != 0) {
      return (
        await DirectMessageModel.find({ friendshipId: friendshipId })
          .sort({ createdAt: -1 })
          .limit(amount ?? 0)
      ).map((message) => message.toObject());
    } else {
      return [];
    }
  }
}
