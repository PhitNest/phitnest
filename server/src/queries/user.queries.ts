import mongoose from "mongoose";
import { IUserModel, User } from "../models/user.model";

export class UserQueries {
  static createUser(
    id: string,
    gymId: string,
    email: string,
    firstName: string,
    lastName: string
  ): Promise<IUserModel> {
    return User.create({
      cognitoId: id,
      gymId: new mongoose.Types.ObjectId(gymId),
      email: email,
      firstName: firstName,
      lastName: lastName,
    });
  }
}
