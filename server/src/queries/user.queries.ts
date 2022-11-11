import mongoose from "mongoose";
import { IUserModel, User } from "../models/user.model";

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
  ): Promise<IUserModel[]> {
    return User.aggregate([]);
  }
}
