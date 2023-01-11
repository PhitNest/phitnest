import { Either } from "typescript-monads";
import { kFriendRequestNotFound } from "../../common/failures";
import { IFriendRequestEntity } from "../../entities";
import { FriendRequestModel } from "../../mongo";
import { IFriendRequestRepository } from "../interfaces";

export class MongoFriendRequestRepository implements IFriendRequestRepository {
  getByFromCognitoId(fromCognitoId: string) {
    return FriendRequestModel.find({ fromCognitoId: fromCognitoId })
      .sort({ createdAt: -1 })
      .exec();
  }

  getByToCognitoId(toCognitoId: string) {
    return FriendRequestModel.find({ toCognitoId: toCognitoId })
      .sort({ createdAt: -1 })
      .exec();
  }

  async getByCognitoIds(fromCognitoId: string, toCognitoId: string) {
    const friendRequest = await FriendRequestModel.findOne({
      fromCognitoId: fromCognitoId,
      toCognitoId: toCognitoId,
    });
    if (friendRequest) {
      return new Either<IFriendRequestEntity, typeof kFriendRequestNotFound>(
        friendRequest
      );
    } else {
      return new Either<IFriendRequestEntity, typeof kFriendRequestNotFound>(
        undefined,
        kFriendRequestNotFound
      );
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

  create(fromCognitoId: string, toCognitoId: string) {
    return FriendRequestModel.create({
      fromCognitoId: fromCognitoId,
      toCognitoId: toCognitoId,
    });
  }
}
