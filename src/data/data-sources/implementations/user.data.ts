import { kUserNotFound } from "../../../common/failures";
import { ICognitoUser } from "../../../domain/entities";
import { UserModel } from "../../mongo";
import { IUserDatabase } from "../interfaces";

export class MongoUserDatabase implements IUserDatabase {
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
      return user.toObject();
    } else {
      return kUserNotFound;
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
      return user.toObject();
    } else {
      return kUserNotFound;
    }
  }

  async create(user: ICognitoUser) {
    return (await UserModel.create(user)).toObject();
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

  async getByGym(gymId: string) {
    return (await UserModel.find({ gymId: gymId })).map((user) =>
      user.toObject()
    );
  }
}
