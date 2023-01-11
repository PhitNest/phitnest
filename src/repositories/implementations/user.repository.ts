import mongoose from "mongoose";
import { Either } from "typescript-monads";
import { kUserNotFound } from "../../common/failures";
import { ICognitoUser, IUserEntity } from "../../entities";
import { IUserRepository } from "../interfaces";
import { GYM_MODEL_NAME } from "./gym.repository";

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

const UserModel = mongoose.model<IUserEntity>(USER_MODEL_NAME, schema);

export class MongoUserRepository implements IUserRepository {
  async deleteAll() {
    await UserModel.deleteMany({});
  }

  async setConfirmed(cognitoId: string) {
    if (
      (await UserModel.updateOne({ cognitoId: cognitoId }, { confirmed: true }))
        .matchedCount !== 1
    ) {
      return kUserNotFound;
    }
  }

  async getByEmail(email: string) {
    const user = await UserModel.findOne({ email: email });
    if (user) {
      return new Either<IUserEntity, typeof kUserNotFound>(user);
    } else {
      return new Either<IUserEntity, typeof kUserNotFound>(
        undefined,
        kUserNotFound
      );
    }
  }

  async delete(cognitoId: string) {
    if (!(await UserModel.findOneAndDelete({ cognitoId: cognitoId }))) {
      return kUserNotFound;
    }
  }

  async get(cognitoId: string) {
    const user = await UserModel.findOne({ cognitoId: cognitoId });
    if (user) {
      return new Either<IUserEntity, typeof kUserNotFound>(user);
    } else {
      return new Either<IUserEntity, typeof kUserNotFound>(
        undefined,
        kUserNotFound
      );
    }
  }

  create(user: ICognitoUser) {
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
