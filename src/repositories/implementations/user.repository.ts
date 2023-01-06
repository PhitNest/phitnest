import { injectable } from "inversify";
import mongoose from "mongoose";
import {
  IConversationEntity,
  IRegisteredUser,
  IUserEntity,
  RelationshipType,
} from "../../entities";
import { IUserRepository } from "../interfaces";
import { GYM_MODEL_NAME } from "./gym.repository";
import { RELATIONSHIP_COLLECTION_NAME } from "./relationship.repository";

export const USER_COLLECTION_NAME = "users";
export const USER_MODEL_NAME = "User";

const schema = new mongoose.Schema(
  {
    cognitoId: { type: String, required: true, unique: true, trim: true },
    gymId: {
      type: mongoose.Types.ObjectId,
      ref: GYM_MODEL_NAME,
      required: true,
    },
    email: {
      type: String,
      format: "email",
      required: true,
      unique: true,
      trim: true,
    },
    firstName: { type: String, required: true, trim: true },
    lastName: { type: String, required: true, trim: true },
    confirmed: { type: Boolean, default: false },
  },
  {
    collection: USER_COLLECTION_NAME,
  }
);

schema.index({ gymId: 1 });

export const UserModel = mongoose.model<IRegisteredUser>(
  USER_MODEL_NAME,
  schema
);

@injectable()
export class MongoUserRepository implements IUserRepository {
  async deleteAll() {
    await UserModel.deleteMany({}).exec();
  }

  tutorialExploreUsers(gymId: string, skip?: number, limit?: number) {
    const pipeline: mongoose.PipelineStage[] = [
      {
        $match: {
          gymId: new mongoose.Types.ObjectId(gymId),
          confirmed: true,
        },
      },
      {
        $project: {
          cognitoId: 1,
          firstName: 1,
          lastName: 1,
        },
      },
    ];
    if (skip && skip > 0) {
      pipeline.push({
        $skip: skip,
      });
    }
    if (limit && limit > 0) {
      pipeline.push({
        $limit: limit,
      });
    }
    return UserModel.aggregate(pipeline).exec();
  }

  async confirmUser(cognitoId: string) {
    await UserModel.updateOne({ cognitoId: cognitoId }, { confirmed: true });
  }

  getByEmail(email: string) {
    return UserModel.findOne({ email: email }).exec();
  }

  exploreUsers(cognitoId: string, skip?: number, limit?: number) {
    const pipeline: mongoose.PipelineStage[] = [
      {
        $match: {
          cognitoId: cognitoId,
        },
      },
      {
        $lookup: {
          from: USER_COLLECTION_NAME,
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
                confirmed: true,
              },
            },
            {
              $lookup: {
                from: RELATIONSHIP_COLLECTION_NAME,
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
                from: RELATIONSHIP_COLLECTION_NAME,
                localField: "cognitoId",
                foreignField: "sender",
                as: "blocks",
                pipeline: [
                  {
                    $match: {
                      recipient: cognitoId,
                      type: RelationshipType.Blocked,
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
                            $size: "$blocks",
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
          firstName: 1,
          lastName: 1,
        },
      },
    ];
    if (skip && skip > 0) {
      pipeline.push({
        $skip: skip,
      });
    }
    if (limit && limit > 0) {
      pipeline.push({
        $limit: limit,
      });
    }
    return UserModel.aggregate(pipeline).exec();
  }

  async populateConversationMembers(conversation: IConversationEntity) {
    return {
      _id: conversation._id,
      archived: conversation.archived,
      users: await UserModel.aggregate([
        { $match: { cognitoId: { $in: conversation.users } } },
        {
          $project: {
            gymId: 1,
            cognitoId: 1,
            firstName: 1,
            lastName: 1,
          },
        },
      ]),
    };
  }

  async delete(cognitoId: string) {
    return (
      (await UserModel.deleteOne({ cognitoId: cognitoId })).deletedCount > 0
    );
  }

  get(cognitoId: string) {
    return UserModel.findOne({ cognitoId: cognitoId }).exec();
  }

  create(user: Omit<IUserEntity, "_id">) {
    return UserModel.create(user);
  }

  async haveSameGym(cognitoId1: string, cognitoId2: string) {
    return (
      (
        await UserModel.aggregate([
          {
            $match: {
              cognitoId: {
                $in: [cognitoId1, cognitoId2],
              },
            },
          },
          {
            $group: {
              _id: "$gymId",
              users: {
                $push: "$$ROOT",
              },
            },
          },
          {
            $match: {
              $expr: {
                $eq: [
                  {
                    $size: "$users",
                  },
                  2,
                ],
              },
            },
          },
        ]).exec()
      ).length === 1
    );
  }
}
