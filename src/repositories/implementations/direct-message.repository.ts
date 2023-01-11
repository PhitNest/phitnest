import { kDirectMessageNotFound } from "../../common/failures";
import { IDirectMessageEntity } from "../../entities";
import { DirectMessageModel } from "../../mongo";
import { IDirectMessageRepository } from "../interfaces";

export class MongoDirectMessageRepository implements IDirectMessageRepository {
  create(message: Omit<IDirectMessageEntity, "_id" | "createdAt">) {
    return DirectMessageModel.create(message);
  }

  async deleteAll() {
    await DirectMessageModel.deleteMany({});
  }

  async get(friendshipId: string, amount?: number) {
    if (amount != 0) {
      return DirectMessageModel.find({ friendshipId: friendshipId })
        .sort({ createdAt: -1 })
        .limit(amount ?? 0)
        .exec();
    } else {
      return [];
    }
  }

  async delete(messageId: string) {
    if (!(await DirectMessageModel.findByIdAndDelete(messageId))) {
      return kDirectMessageNotFound;
    }
  }
}
