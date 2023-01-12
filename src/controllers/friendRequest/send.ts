import { AuthenticatedLocals, IRequest, IResponse } from "../../common/types";
import { z } from "zod";
import { Controller, HttpMethod } from "../types";
import { authMiddleware } from "../../middleware";
import { IFriendRequestEntity, IFriendshipEntity } from "../../entities";
import { sendFriendRequest } from "../../use-cases";

const sendFriendRequestValidator = z.object({
  recipientCognitoId: z.string(),
});

type SendFriendRequestRequest = z.infer<typeof sendFriendRequestValidator>;

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
    return sendFriendRequestValidator.parse(body);
  }

  execute(
    req: IRequest<SendFriendRequestRequest>,
    res: IResponse<SendFriendRequestResponse, AuthenticatedLocals>
  ) {
    return sendFriendRequest(res.locals.cognitoId, req.body.recipientCognitoId);
  }
}
