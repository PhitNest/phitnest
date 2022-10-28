import { IUserModel, User } from "../models/user.model";

export class UserQueries {
  static createUser(
    id: string,
    email: string,
    firstName: string,
    lastName: string
  ): Promise<IUserModel> {
    return User.create({
      cognitoId: id,
      email: email,
      firstName: firstName,
      lastName: lastName,
    });
  }
}
