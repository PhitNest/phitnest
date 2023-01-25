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

const validator = z.object({
  friendCognitoId: z.string(),
});

type GetDirectMessagesRequest = z.infer<typeof validator>;

export class GetDirectMessagesController
  implements
    Controller<
      GetDirectMessagesRequest,
      IDirectMessageEntity[],
      AuthenticatedLocals
    >
{
  method = HttpMethod.GET;

  middleware = [authMiddleware];

  validate(body: any) {
    return validator.parse(body);
  }

  execute(
    req: IRequest<GetDirectMessagesRequest>,
    res: IResponse<IDirectMessageEntity[], AuthenticatedLocals>
  ) {
    return getDirectMessages([res.locals.cognitoId, req.body.friendCognitoId]);
  }
}
