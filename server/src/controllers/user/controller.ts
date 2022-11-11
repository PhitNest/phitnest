import { Request, Response } from "express";
import { UserQueries } from "../../queries/user.queries";
import { IUserModel } from "../../models/user.model";

function publicDataResponse(user: IUserModel) {
  return {
    id: user._id,
    firstName: user.firstName,
    lastName: user.lastName,
  };
}

function privateDataResponse(user: IUserModel) {
  return {
    id: user._id,
    cognitoId: user.cognitoId,
    gymId: user.gymId,
    firstName: user.firstName,
    lastName: user.lastName,
  };
}

class UserController {
  async myData(req: Request, res: Response) {
    return res
      .status(200)
      .json(
        privateDataResponse(await UserQueries.getUser(res.locals.cognitoId))
      );
  }
}

export default new UserController();
