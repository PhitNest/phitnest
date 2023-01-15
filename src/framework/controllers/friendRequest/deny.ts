import {
  AuthenticatedLocals,
  IRequest,
  IResponse,
} from "../../../common/types";
import { z } from "zod";
import { Controller, HttpMethod } from "../types";
import { authMiddleware } from "../../middleware";
import { friendRequestRepo } from "../../../domain/repositories";

const denyFriendRequestValidator = z.object({
  senderCognitoId: z.string(),
});

type DenyFriendRequestRequest = z.infer<typeof denyFriendRequestValidator>;

export class DenyFriendRequestController
  implements Controller<DenyFriendRequestRequest, void, AuthenticatedLocals>
{
  method = HttpMethod.POST;

  middleware = [authMiddleware];

  validate(body: any) {
    return denyFriendRequestValidator.parse(body);
  }

  execute(
    req: IRequest<DenyFriendRequestRequest>,
    res: IResponse<void, AuthenticatedLocals>
  ) {
    return friendRequestRepo.deny(
      req.body.senderCognitoId,
      res.locals.cognitoId
    );
  }
}
