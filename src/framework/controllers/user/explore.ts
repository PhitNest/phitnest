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

type ExploreResponse = {
  users: IProfilePicturePublicUserEntity[];
  requests: IFriendRequestEntity[];
};

export class ExploreController implements Controller<ExploreResponse> {
  validator = z.object({
    gymId: z.string(),
  });

  route = "/user/explore";

  method = HttpMethod.GET;

  middleware = [authMiddleware];

  execute(
    req: IRequest<z.infer<typeof this.validator>>,
    res: IResponse<ExploreResponse, AuthenticatedLocals>
  ) {
    return explore(res.locals.cognitoId, req.body.gymId);
  }
}
