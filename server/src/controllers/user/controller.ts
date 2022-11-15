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

  async delete(req: Request, res: Response) {
    await UserQueries.delete(res.locals.cognitoId);
    return res.status(200).send("SUCCESS");
  }
}

export default new UserController();
