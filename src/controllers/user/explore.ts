import { AuthenticatedLocals, IRequest, IResponse } from "../../common/types";
import { z } from "zod";
import { Controller, HttpMethod } from "../types";
import { authMiddleware } from "../../middleware";
import { IFriendRequestEntity, IPublicUserEntity } from "../../entities";
import { explore } from "../../use-cases";

const exploreValidator = z.object({
  gymId: z.string(),
});

type ExploreRequest = z.infer<typeof exploreValidator>;

type ExploreResponse = {
  users: IPublicUserEntity[];
  requests: IFriendRequestEntity[];
};

export class ExploreController
  implements Controller<ExploreRequest, ExploreResponse, AuthenticatedLocals>
{
  method = HttpMethod.GET;

  middleware = [authMiddleware];

  validate(body: any) {
    return exploreValidator.parse(body);
  }

  execute(
    req: IRequest<ExploreRequest>,
    res: IResponse<ExploreResponse, AuthenticatedLocals>
  ) {
    return explore(res.locals.cognitoId, req.body.gymId);
  }
}
