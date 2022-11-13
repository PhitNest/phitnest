import mongoose from "mongoose";
import { IPublicUserModel, IUserModel, User } from "../models/user.model";
import { UserRelationshipType } from "../models/userRelationship.model";

export class UserQueries {
  static createUser(
    cognitoId: string,
    gymId: string,
    email: string,
    firstName: string,
    lastName: string
  ): Promise<IUserModel> {
    return User.create({
      cognitoId: cognitoId,
      gymId: new mongoose.Types.ObjectId(gymId),
      email: email,
      firstName: firstName,
      lastName: lastName,
    });
  }

  static async getPrivateUserData(cognitoId: string): Promise<IUserModel> {
    return (
      await User.aggregate([
        { $match: { cognitoId: cognitoId } },
        {
          $project: {
            cognitoId: 1,
            gymId: 1,
            email: 1,
            firstName: 1,
            lastName: 1,
          },
        },
      ])
    )[0];
  }

  static async explore(
    cognitoId: string,
    offset: number | null,
    limit: number | null
  ): Promise<IPublicUserModel[]> {
    return User.aggregate([
      {
        $match: {
          cognitoId: cognitoId,
        },
      },
      {
        $lookup: {
          from: "users",
          localField: "gymId",
          foreignField: "gymId",
          as: "users",
          pipeline: [
            {
              $match: {
                cognitoId: {
                  $not: {
                    $eq: cognitoId,
                  },
                },
              },
            },
            {
              $lookup: {
                from: "user_relationships",
                localField: "cognitoId",
                foreignField: "recipient",
                as: "sent",
                pipeline: [
                  {
                    $match: {
                      sender: cognitoId,
                    },
                  },
                ],
              },
            },
            {
              $lookup: {
                from: "user_relationships",
                localField: "cognitoId",
                foreignField: "sender",
                as: "denies",
                pipeline: [
                  {
                    $match: {
                      recipient: cognitoId,
                      $or: [
                        {
                          type: UserRelationshipType.Denied,
                        },
                        {
                          type: UserRelationshipType.Blocked,
                        },
                      ],
                    },
                  },
                ],
              },
            },
            {
              $match: {
                $expr: {
                  $not: {
                    $or: [
                      {
                        $gt: [
                          {
                            $size: "$sent",
                          },
                          0,
                        ],
                      },
                      {
                        $gt: [
                          {
                            $size: "$denies",
                          },
                          0,
                        ],
                      },
                    ],
                  },
                },
              },
            },
          ],
        },
      },
      {
        $unwind: {
          path: "$users",
        },
      },
      {
        $replaceRoot: {
          newRoot: "$users",
        },
      },
      {
        $project: {
          cognitoId: 1,
          gymId: 1,
          firstName: 1,
          lastName: 1,
        },
      },
      {
        $skip: offset,
      },
      {
        $limit: limit,
      },
    ]);
  }
}
