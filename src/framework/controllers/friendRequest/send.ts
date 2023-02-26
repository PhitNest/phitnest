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
  IPopulatedFriendRequestEntity,
  IPopulatedFriendshipEntity,
} from "../../../domain/entities";
import { sendFriendRequest } from "../../../domain/use-cases";
import { getSocketServer } from "../../adapters/injection";

type SendFriendRequestResponse =
  | IPopulatedFriendRequestEntity
  | IPopulatedFriendshipEntity;

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
      const request = result as IPopulatedFriendRequestEntity;
      if (request.fromUser) {
        getSocketServer().emit(
          "friendRequest",
          request,
          req.body.recipientCognitoId
        );
      } else {
        getSocketServer().emit(
          "friendship",
          result,
          req.body.recipientCognitoId
        );
      }
      return result;
    }
  }
}
