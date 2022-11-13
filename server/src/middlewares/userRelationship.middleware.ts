import { Request, Response, NextFunction } from "express";

class UserRelationshipMiddleware {
  validate(req: Request, res: Response, next: NextFunction) {
    if (req.body.recipientId == res.locals.cognitoId) {
      next({ message: "Invalid recipient ID" });
    } else {
      next();
    }
  }
}

export default new UserRelationshipMiddleware();
