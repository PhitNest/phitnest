import {
  AuthenticatedLocals,
  IRequest,
  IResponse,
} from "../../../common/types";
import { z } from "zod";
import { Controller, HttpMethod } from "../types";
import { authMiddleware } from "../../middleware";
import {
  IFriendRequestEntity,
  IProfilePicturePublicUserEntity,
} from "../../../domain/entities";
import { explore } from "../../../domain/use-cases";

const validator = z.object({
  gymId: z.string(),
});

type ExploreRequest = z.infer<typeof validator>;

type ExploreResponse = {
  users: IProfilePicturePublicUserEntity[];
  requests: IFriendRequestEntity[];
};

export class ExploreController
  implements Controller<ExploreRequest, ExploreResponse, AuthenticatedLocals>
{
  method = HttpMethod.GET;

  middleware = [authMiddleware];

  validate(body: any) {
    return validator.parse(body);
  }

  execute(
    req: IRequest<ExploreRequest>,
    res: IResponse<ExploreResponse, AuthenticatedLocals>
  ) {
    return explore(res.locals.cognitoId, req.body.gymId);
  }
}
