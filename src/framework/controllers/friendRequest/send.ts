import {
  AuthenticatedLocals,
  Failure,
  IRequest,
  IResponse,
} from "../../../common/types";
import { z } from "zod";
import { Controller, HttpMethod } from "../types";
import { authMiddleware } from "../../middleware";
import {
  IFriendRequestEntity,
  IFriendshipEntity,
} from "../../../domain/entities";
import { sendFriendRequest } from "../../../domain/use-cases";
import { getSocketServer } from "../../adapters/injection";

type SendFriendRequestResponse = IFriendRequestEntity | IFriendshipEntity;

export class SendFriendRequestController
  implements Controller<SendFriendRequestResponse>
{
  method = HttpMethod.POST;

  route = "/friendRequest";

  validator = z.object({
    recipientCognitoId: z.string(),
  });

  middleware = [authMiddleware];

  async execute(
    req: IRequest<z.infer<typeof this.validator>>,
    res: IResponse<SendFriendRequestResponse, AuthenticatedLocals>
  ) {
    const result = await sendFriendRequest(
      res.locals.cognitoId,
      req.body.recipientCognitoId
    );
    if (result instanceof Failure) {
      return result;
    } else {
      getSocketServer().emit(
        "friendRequest",
        result,
        req.body.recipientCognitoId
      );
      return result;
    }
  }
}
