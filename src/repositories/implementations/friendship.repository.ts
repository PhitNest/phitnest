import { kFriendshipNotFound } from "../../common/failures";
import { Failure } from "../../common/types";
import { IFriendshipEntity } from "../../entities";
import { FriendshipModel } from "../../mongo";
import { IFriendshipRepository } from "../interfaces";

export class MongoFriendshipRepository implements IFriendshipRepository {
  async create(userCognitoIds: [string, string]): Promise<IFriendshipEntity> {
    return (
      await FriendshipModel.create({
        userCognitoIds: userCognitoIds.sort(),
      })
    ).toObject();
  }

  async deleteAll() {
    await FriendshipModel.deleteMany({});
  }

  async get(cognitoId: string): Promise<IFriendshipEntity[]> {
    return (
      await FriendshipModel.find({ userCognitoIds: cognitoId }).sort({
        createdAt: -1,
      })
    ).map((friendship) => friendship.toObject());
  }

  async getByUsers(
    userCognitoIds: [string, string]
  ): Promise<IFriendshipEntity | Failure> {
    const friendship = await FriendshipModel.findOne({
      userCognitoIds: userCognitoIds.sort(),
    });
    if (friendship) {
      return friendship.toObject();
    } else {
      return kFriendshipNotFound;
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
