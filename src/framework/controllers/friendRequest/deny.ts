import {
  AuthenticatedLocals,
  IRequest,
  IResponse,
} from "../../../common/types";
import { z } from "zod";
import { Controller, HttpMethod } from "../types";
import { authMiddleware } from "../../middleware";
import { databases().friendRequestDatabase } from "../../../domain/repositories";

export class DenyFriendRequestController implements Controller<void> {
  method = HttpMethod.POST;

  route = "/friendRequest/deny";

  middleware = [authMiddleware];

  validator = z.object({
    senderCognitoId: z.string(),
  });

  execute(
    req: IRequest<z.infer<typeof this.validator>>,
    res: IResponse<void, AuthenticatedLocals>
  ) {
    return databases().friendRequestDatabase.deny(
      req.body.senderCognitoId,
      res.locals.cognitoId
    );
  }
}
