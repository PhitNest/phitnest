import { AuthenticatedLocals, IRequest, IResponse } from "../../common/types";
import { z } from "zod";
import { Controller, HttpMethod } from "../types";
import { authMiddleware } from "../../middleware";
import { removeFriend } from "../../use-cases";

const removeFriendValidator = z.object({
  friendCognitoId: z.string(),
});

type RemoveFriendRequest = z.infer<typeof removeFriendValidator>;

export class RemoveFriendController
  implements Controller<RemoveFriendRequest, void, AuthenticatedLocals>
{
  method = HttpMethod.DELETE;

  middleware = [authMiddleware];

  validate(body: any) {
    return removeFriendValidator.parse(body);
  }

  execute(
    req: IRequest<RemoveFriendRequest>,
    res: IResponse<void, AuthenticatedLocals>
  ) {
    return removeFriend(res.locals.cognitoId, req.body.friendCognitoId);
  }
}
