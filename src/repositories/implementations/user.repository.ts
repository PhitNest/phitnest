import { Either } from "typescript-monads";
import { kUserNotFound } from "../../common/failures";
import { ICognitoUser, IUserEntity } from "../../entities";
import { UserModel } from "../../mongo";
import { IUserRepository } from "../interfaces";

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
