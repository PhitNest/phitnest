import { injectable } from "inversify";
import mongoose from "mongoose";
import { IUserEntity, RelationshipType } from "../../entities";
import { IUserRepository } from "../interfaces";
import { GYM_MODEL_NAME } from "./gym.repository";
import { RELATIONSHIP_COLLECTION_NAME } from "./relationship.repository";

export const USER_COLLECTION_NAME = "users";
export const USER_MODEL_NAME = "User";

const schema = new mongoose.Schema(
  {
    gymId: {
      type: mongoose.Types.ObjectId,
      ref: GYM_MODEL_NAME,
      required: true,
    },
    email: { type: String, required: true, unique: true, trim: true },
    firstName: { type: String, required: true, trim: true },
    lastName: { type: String, required: true, trim: true },
  },
  {
    collection: USER_COLLECTION_NAME,
  }
);

schema.index({ gymId: 1 });

export const UserModel = mongoose.model<IUserEntity>(USER_MODEL_NAME, schema);

@injectable()
export class MongoUserRepository implements IUserRepository {
  exploreUsers(userId: string, offset?: number, limit?: number) {
    return UserModel.aggregate([
      {
        $match: {
          _id: userId,
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
                _id: {
                  $not: {
                    $eq: userId,
                  },
                },
              },
            },
            {
              $lookup: {
                from: RELATIONSHIP_COLLECTION_NAME,
                localField: "_id",
                foreignField: "recipient",
                as: "sent",
                pipeline: [
                  {
                    $match: {
                      sender: userId,
                    },
                  },
                ],
              },
            },
            {
              $lookup: {
                from: RELATIONSHIP_COLLECTION_NAME,
                localField: "_id",
                foreignField: "sender",
                as: "blocks",
                pipeline: [
                  {
                    $match: {
                      recipient: userId,
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
          id: {
            _id: 1,
          },
          gymId: 1,
          firstName: 1,
          lastName: 1,
        },
      },
      {
        $skip: offset ?? 0,
      },
      {
        $limit: limit ?? 0,
      },
    ]).exec();
  }

  async delete(userId: string) {
    await UserModel.deleteOne({ _id: userId });
  }

  async create(user: IUserEntity) {
    try {
      await UserModel.create({
        ...user,
        gymId: new mongoose.Types.ObjectId(user.gymId),
      });
      return true;
    } catch (error) {
      return false;
    }
  }
}
