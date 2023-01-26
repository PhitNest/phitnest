import {
  AuthenticatedLocals,
  IRequest,
  IResponse,
} from "../../../common/types";
import { z } from "zod";
import { Controller, HttpMethod } from "../types";
import { authMiddleware } from "../../middleware";
import { removeFriend } from "../../../domain/use-cases";

export class RemoveFriendController implements Controller<void> {
  method = HttpMethod.DELETE;

  route = "/friendship";

  middleware = [authMiddleware];

  validator = z.object({
    friendCognitoId: z.string(),
  });

  execute(
    req: IRequest<z.infer<typeof this.validator>>,
    res: IResponse<void, AuthenticatedLocals>
  ) {
    return removeFriend(res.locals.cognitoId, req.body.friendCognitoId);
  }
}
