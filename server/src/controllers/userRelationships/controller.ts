import { Request, Response } from "express";
import errorHandler from "../../middlewares/error.middleware";
import { UserRelationshipQueries } from "../../queries/userRelationship.queries";

class UserRelationshipController {
  async myFriends(req: Request, res: Response) {
    res
      .status(200)
      .json(await UserRelationshipQueries.myFriends(res.locals.cognitoId));
  }

  async unblock(req: Request, res: Response) {
    await UserRelationshipQueries.unblock(
      res.locals.cognitoId,
      req.body.recipientId.toString()
    );
    res.status(200).send("SUCCESS");
  }

  async block(req: Request, res: Response) {
    if (
      await UserRelationshipQueries.block(
        res.locals.cognitoId,
        req.body.recipientId.toString()
      )
    ) {
      res.status(200).send("SUCCESS");
    } else {
      return errorHandler({ message: "Invalid Cognito ID" }, req, res);
    }
  }

  async myRequests(req: Request, res: Response) {
    res
      .status(200)
      .json(await UserRelationshipQueries.myRequests(res.locals.cognitoId));
  }

  async denyRequest(req: Request, res: Response) {
    if (
      await UserRelationshipQueries.denyRequest(
        res.locals.cognitoId,
        req.body.recipientId.toString()
      )
    ) {
      res.status(200).send("SUCCESS");
    } else {
      return errorHandler({ message: "Invalid Cognito ID" }, req, res);
    }
  }

  async sendRequest(req: Request, res: Response) {
    if (
      await UserRelationshipQueries.sendRequest(
        res.locals.cognitoId,
        req.body.recipientId
      )
    ) {
      res.status(200).send("SUCCESS");
    } else {
      return errorHandler({ message: "Invalid Cognito ID" }, req, res);
    }
  }
}

export default new UserRelationshipController();
