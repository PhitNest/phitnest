import { IDirectMessageEntity } from "../../../domain/entities";
import { DirectMessageModel } from "../../mongo";
import { IDirectMessageDatabase } from "../interfaces";

export class MongoDirectMessageDatabase implements IDirectMessageDatabase {
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
