import { IPublicUserModel } from "../models/user.model";
import {
  UserRelationship,
  UserRelationshipType,
} from "../models/userRelationship.model";

export class UserRelationshipQueries {
  static async block(cognitoId: string, otherUserCognitoId: string) {
    await UserRelationship.findOneAndUpdate(
      { sender: cognitoId, recipient: otherUserCognitoId },
      { type: UserRelationshipType.Blocked },
      { upsert: true }
    );
  }

  static async sendRequest(cognitoId: string, otherUserCognitoId: string) {
    await UserRelationship.findOneAndUpdate(
      { sender: cognitoId, recipient: otherUserCognitoId },
      { type: UserRelationshipType.Requested },
      { upsert: true }
    );
  }

  static async denyRequest(cognitoId: string, otherUserCognitoId: string) {
    await UserRelationship.findOneAndUpdate(
      { sender: cognitoId, recipient: otherUserCognitoId },
      { type: UserRelationshipType.Denied },
      { upsert: true }
    );
  }

  static async myFriends(cognitoId: string) {
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
