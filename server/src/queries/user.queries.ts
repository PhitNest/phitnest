import { IUserModel, User } from "../models/user.model";

class UserQueries {
  createUser(
    id: string,
    email: string,
    firstName: string,
    lastName: string
  ): Promise<IUserModel> {
    return User.create({
      id: id,
      email: email,
      firstName: firstName,
      lastName: lastName,
    });
  }
}

export default new UserQueries();
