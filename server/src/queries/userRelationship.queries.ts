import { IPublicUserModel, User } from "../models/user.model";
import {
  IUserRelationshipModel,
  UserRelationship,
  UserRelationshipType,
} from "../models/userRelationship.model";

export class UserRelationshipQueries {
  static async block(
    cognitoId: string,
    otherUserCognitoId: string
  ): Promise<IUserRelationshipModel> {
    if ((await User.find({ cognitoId: otherUserCognitoId })).length) {
      return await UserRelationship.findOneAndUpdate(
        { sender: cognitoId, recipient: otherUserCognitoId },
        { type: UserRelationshipType.Blocked },
        { upsert: true, new: true }
      );
    }
  }

  static async unblock(cognitoId: string, otherUserCognitoId: string) {
    await UserRelationship.deleteOne({
      sender: cognitoId,
      recipient: otherUserCognitoId,
      type: UserRelationshipType.Blocked,
    });
  }

  static async sendRequest(
    cognitoId: string,
    otherUserCognitoId: string
  ): Promise<IUserRelationshipModel> {
    if ((await User.find({ cognitoId: otherUserCognitoId })).length) {
      return await UserRelationship.findOneAndUpdate(
        { sender: cognitoId, recipient: otherUserCognitoId },
        { type: UserRelationshipType.Requested },
        { upsert: true, new: true }
      );
    }
  }

  static async denyRequest(
    cognitoId: string,
    otherUserCognitoId: string
  ): Promise<IUserRelationshipModel> {
    if ((await User.find({ cognitoId: otherUserCognitoId })).length) {
      return await UserRelationship.findOneAndUpdate(
        { sender: cognitoId, recipient: otherUserCognitoId },
        { type: UserRelationshipType.Denied },
        { upsert: true, new: true }
      );
    }
  }

  static async mySentRequests(cognitoId: string): Promise<IPublicUserModel[]> {
    return UserRelationship.aggregate([
      {
        $match: {
          sender: cognitoId,
          type: UserRelationshipType.Requested,
        },
      },
      {
        $lookup: {
          from: "user_relationships",
          localField: "recipient",
          foreignField: "sender",
          pipeline: [
            {
              $match: {
                recipient: cognitoId,
              },
            },
          ],
          as: "response",
        },
      },
      {
        $match: {
          $expr: {
            $not: {
              $gt: [
                {
                  $size: "$response",
                },
                0,
              ],
            },
          },
        },
      },
      {
        $lookup: {
          from: "users",
          localField: "recipient",
          foreignField: "cognitoId",
          as: "users",
        },
      },
      {
        $project: {
          cognitoId: {
            $first: "$users.cognitoId",
          },
          gymId: {
            $first: "$users.gymId",
          },
          firstName: {
            $first: "$users.firstName",
          },
          lastName: {
            $first: "$users.lastName",
          },
        },
      },
    ]);
  }

  static async myReceivedRequests(
    cognitoId: string
  ): Promise<IPublicUserModel[]> {
    return UserRelationship.aggregate([
      {
        $match: {
          recipient: cognitoId,
          type: UserRelationshipType.Requested,
        },
      },
      {
        $lookup: {
          from: "user_relationships",
          localField: "sender",
          foreignField: "recipient",
          pipeline: [
            {
              $match: {
                sender: cognitoId,
              },
            },
          ],
          as: "response",
        },
      },
      {
        $match: {
          $expr: {
            $not: {
              $gt: [
                {
                  $size: "$response",
                },
                0,
              ],
            },
          },
        },
      },
      {
        $lookup: {
          from: "users",
          localField: "sender",
          foreignField: "cognitoId",
          as: "users",
        },
      },
      {
        $project: {
          cognitoId: {
            $first: "$users.cognitoId",
          },
          gymId: {
            $first: "$users.gymId",
          },
          firstName: {
            $first: "$users.firstName",
          },
          lastName: {
            $first: "$users.lastName",
          },
        },
      },
    ]);
  }

  static async myFriends(cognitoId: string): Promise<IPublicUserModel[]> {
    return UserRelationship.aggregate([
      {
        $match: {
          sender: cognitoId,
          type: UserRelationshipType.Requested,
        },
      },
      {
        $lookup: {
          from: "user_relationships",
          localField: "recipient",
          foreignField: "sender",
          as: "friends",
          pipeline: [
            {
              $match: {
                recipient: cognitoId,
                type: UserRelationshipType.Requested,
              },
            },
          ],
        },
      },
      {
        $match: {
          friends: {
            $gt: [
              {
                $size: "$friends",
              },
              0,
            ],
          },
        },
      },
      {
        $project: {
          friendId: {
            $first: "$friends.sender",
          },
        },
      },
      {
        $lookup: {
          from: "users",
          localField: "friendId",
          foreignField: "cognitoId",
          as: "friend",
        },
      },
      {
        $project: {
          cognitoId: {
            $first: "$friend.cognitoId",
          },
          gymId: {
            $first: "$friend.gymId",
          },
          firstName: {
            $first: "$friend.firstName",
          },
          lastName: {
            $first: "$friend.lastName",
          },
        },
      },
    ]);
  }
}
