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

const validator = z.object({
  recipientCognitoId: z.string(),
});

type SendFriendRequestRequest = z.infer<typeof validator>;

type SendFriendRequestResponse = IFriendRequestEntity | IFriendshipEntity;

export class SendFriendRequestController
  implements
    Controller<
      SendFriendRequestRequest,
      SendFriendRequestResponse,
      AuthenticatedLocals
    >
{
  method = HttpMethod.POST;

  middleware = [authMiddleware];

  validate(body: any) {
    return validator.parse(body);
  }

  async execute(
    req: IRequest<SendFriendRequestRequest>,
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
