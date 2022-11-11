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

  static getUser(cognitoId: string): Promise<IUserModel> {
    return User.findOne({ cognitoId: cognitoId }).exec();
  }
}
