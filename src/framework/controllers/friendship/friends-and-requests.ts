import {
  AuthenticatedLocals,
  IRequest,
  IResponse,
} from "../../../common/types";
import { Controller, HttpMethod } from "../types";
import { authMiddleware } from "../../middleware";
import {
  IPopulatedFriendRequestEntity,
  IPopulatedFriendshipEntity,
} from "../../../domain/entities";
import { getFriendsAndFriendRequests } from "../../../domain/use-cases";

type FriendsAndRequestsResponse = {
  friendships: IPopulatedFriendshipEntity[];
  requests: IPopulatedFriendRequestEntity[];
};

export class FriendsAndRequestsController
  implements Controller<{}, FriendsAndRequestsResponse, AuthenticatedLocals>
{
  method = HttpMethod.GET;

  middleware = [authMiddleware];

  validate(body: any) {
    return {};
  }

  async execute(
    req: IRequest<{}>,
    res: IResponse<FriendsAndRequestsResponse, AuthenticatedLocals>
  ) {
    return getFriendsAndFriendRequests(res.locals.cognitoId);
  }
}
