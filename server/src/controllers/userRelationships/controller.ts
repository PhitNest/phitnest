import { Request, Response } from "express";
import { UserRelationshipQueries } from "../../queries/userRelationship.queries";

class UserRelationshipController {
  async block(req: Request, res: Response) {
    await UserRelationshipQueries.block(
      res.locals.cognitoId,
      req.query.recipientId.toString()
    );
    res.status(200).send("SUCCESS");
  }

  async denyRequest(req: Request, res: Response) {
    await UserRelationshipQueries.block(
      res.locals.cognitoId,
      req.query.recipientId.toString()
    );
    res.status(200).send("SUCCESS");
  }

  async sendRequest(req: Request, res: Response) {
    await UserRelationshipQueries.block(
      res.locals.cognitoId,
      req.query.recipientId.toString()
    );
    res.status(200).send("SUCCESS");
  }
}

export default new UserRelationshipController();
