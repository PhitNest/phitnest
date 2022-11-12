import { Request, Response } from "express";
import { UserQueries } from "../../queries/user.queries";

class UserController {
  async myData(req: Request, res: Response) {
    return res
      .status(200)
      .json(await UserQueries.getPrivateUserData(res.locals.cognitoId));
  }

  async explore(req: Request, res: Response) {
    return res
      .status(200)
      .json(
        await UserQueries.explore(
          res.locals.cognitoId,
          parseInt(req.query.offset.toString()),
          parseInt(req.query.limit.toString())
        )
      );
  }
}

export default new UserController();
