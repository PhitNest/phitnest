import {
  AuthenticatedLocals,
  IRequest,
  IResponse,
} from "../../../common/types";
import { Controller, HttpMethod } from "../types";
import { authMiddleware } from "../../middleware";
import {
  IDirectMessageEntity,
  IPopulatedFriendshipEntity,
} from "../../../domain/entities";
import { getFriendsAndMessages } from "../../../domain/use-cases";

type FriendsAndMessagesResponse = {
  friendship: IPopulatedFriendshipEntity;
  message: IDirectMessageEntity | undefined;
}[];

export class FriendsAndMessagesController
  implements Controller<FriendsAndMessagesResponse>
{
  method = HttpMethod.GET;

  route = "/friendship/friendsAndMessages";

  middleware = [authMiddleware];

  async execute(
    req: IRequest,
    res: IResponse<FriendsAndMessagesResponse, AuthenticatedLocals>
  ) {
    return getFriendsAndMessages(res.locals.cognitoId);
  }
}
