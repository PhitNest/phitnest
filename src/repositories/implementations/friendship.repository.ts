import mongoose from "mongoose";
import { Either } from "typescript-monads";
import { kFriendshipNotFound } from "../../common/failures";
import { IFriendshipEntity } from "../../entities";
import { IFriendshipRepository } from "../interfaces";

export const FRIENDSHIP_COLLECTION_NAME = "friendships";
export const FRIENDSHIP_MODEL_NAME = "Friendship";

const schema = new mongoose.Schema(
  {
    userCognitoIds: { type: [String], required: true },
  },
  {
    collection: FRIENDSHIP_COLLECTION_NAME,
    timestamps: true,
  }
);

schema.index({ userCognitoIds: 1 });

const FriendshipModel = mongoose.model<IFriendshipEntity>(
  FRIENDSHIP_MODEL_NAME,
  schema
);

export class MongoFriendshipRepository implements IFriendshipRepository {
  create(userCognitoIds: [string, string]) {
    return FriendshipModel.create({ userCognitoIds: userCognitoIds.sort() });
  }

  async deleteAll() {
    await FriendshipModel.deleteMany({});
  }

  get(cognitoId: string) {
    return FriendshipModel.find({ userCognitoIds: cognitoId })
      .sort({ createdAt: -1 })
      .exec();
  }

  async getByUsers(userCognitoIds: [string, string]) {
    const friendship = await FriendshipModel.findOne({
      userCognitoIds: userCognitoIds.sort(),
    });
    if (friendship) {
      return new Either<IFriendshipEntity, typeof kFriendshipNotFound>(
        friendship
      );
    } else {
      return new Either<IFriendshipEntity, typeof kFriendshipNotFound>(
        undefined,
        kFriendshipNotFound
      );
    }
  }

  async delete(userCognitoIds: [string, string]) {
    if (
      !(await FriendshipModel.findOneAndDelete({
        userCognitoIds: userCognitoIds,
      }))
    ) {
      return kFriendshipNotFound;
    }
  }
}
