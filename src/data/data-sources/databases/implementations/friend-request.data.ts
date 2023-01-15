import { kFriendRequestNotFound } from "../../../../common/failures";
import { FriendRequestModel } from "../../../mongo";
import { IFriendRequestDatabase } from "../interfaces";

export class MongoFriendRequestDatabase implements IFriendRequestDatabase {
  async getByFromCognitoId(fromCognitoId: string) {
    return (
      await FriendRequestModel.find({ fromCognitoId: fromCognitoId }).sort({
        createdAt: -1,
      })
    ).map((request) => request.toObject());
  }

  async getByToCognitoId(toCognitoId: string) {
    return (
      await FriendRequestModel.find({ toCognitoId: toCognitoId }).sort({
        createdAt: -1,
      })
    ).map((request) => request.toObject());
  }

  async getByCognitoIds(fromCognitoId: string, toCognitoId: string) {
    const friendRequest = await FriendRequestModel.findOne({
      fromCognitoId: fromCognitoId,
      toCognitoId: toCognitoId,
    });
    if (friendRequest) {
      return friendRequest.toObject();
    } else {
      return kFriendRequestNotFound;
    }
  }

  async deny(fromCognitoId: string, toCognitoId: string) {
    if (
      !(await FriendRequestModel.findOneAndUpdate(
        {
          fromCognitoId: fromCognitoId,
          toCognitoId: toCognitoId,
          denied: false,
        },
        { denied: true }
      ))
    ) {
      return kFriendRequestNotFound;
    }
  }

  async delete(fromCognitoId: string, toCognitoId: string) {
    if (
      !(await FriendRequestModel.findOneAndDelete({
        fromCognitoId: fromCognitoId,
        toCognitoId: toCognitoId,
      }))
    ) {
      return kFriendRequestNotFound;
    }
  }

  async deleteAll() {
    await FriendRequestModel.deleteMany({});
  }

  async create(fromCognitoId: string, toCognitoId: string) {
    return (
      await FriendRequestModel.create({
        fromCognitoId: fromCognitoId,
        toCognitoId: toCognitoId,
      })
    ).toObject();
  }
}
