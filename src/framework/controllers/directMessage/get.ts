import {
  AuthenticatedLocals,
  IRequest,
  IResponse,
} from "../../../common/types";
import { z } from "zod";
import { Controller, HttpMethod } from "../types";
import { authMiddleware } from "../../middleware";
import { IDirectMessageEntity } from "../../../domain/entities";
import { getDirectMessages } from "../../../domain/use-cases";

export class GetDirectMessagesController
  implements Controller<IDirectMessageEntity[]>
{
  method = HttpMethod.GET;

  route = "/directMessage/list";

  middleware = [authMiddleware];

  validator = z.object({
    friendCognitoId: z.string(),
  });

  execute(
    req: IRequest<z.infer<typeof this.validator>>,
    res: IResponse<IDirectMessageEntity[], AuthenticatedLocals>
  ) {
    return getDirectMessages([res.locals.cognitoId, req.body.friendCognitoId]);
  }
}
