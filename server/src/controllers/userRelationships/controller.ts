import { Request, Response } from "express";
import { UserRelationshipQueries } from "../../queries/userRelationship.queries";

class UserRelationshipController {
  async myFriends(req: Request, res: Response) {
    res
      .status(200)
      .json(await UserRelationshipQueries.myFriends(res.locals.cognitoId));
  }

  async block(req: Request, res: Response) {
    await UserRelationshipQueries.block(
      res.locals.cognitoId,
      req.body.recipientId.toString()
    );
    res.status(200).send("SUCCESS");
  }

  async denyRequest(req: Request, res: Response) {
    await UserRelationshipQueries.denyRequest(
      res.locals.cognitoId,
      req.body.recipientId.toString()
    );
    res.status(200).send("SUCCESS");
  }

  async sendRequest(req: Request, res: Response) {
    await UserRelationshipQueries.sendRequest(
      res.locals.cognitoId,
      req.body.recipientId
    );
    res.status(200).send("SUCCESS");
  }
}

export default new UserRelationshipController();
