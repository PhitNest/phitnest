import { AuthenticatedLocals, IRequest, IResponse } from "../../common/types";
import { Controller, HttpMethod } from "../types";
import { authMiddleware } from "../../middleware";
import {
  IDirectMessageEntity,
  IPopulatedFriendshipEntity,
} from "../../entities";
import { getFriendsAndMessages } from "../../use-cases";

type FriendsAndMessagesResponse = {
  friendship: IPopulatedFriendshipEntity;
  message: IDirectMessageEntity | undefined;
}[];

export class FriendsAndMessagesController
  implements Controller<{}, FriendsAndMessagesResponse, AuthenticatedLocals>
{
  method = HttpMethod.GET;

  middleware = [authMiddleware];

  validate(body: any) {
    return {};
  }

  async execute(
    req: IRequest<{}>,
    res: IResponse<FriendsAndMessagesResponse, AuthenticatedLocals>
  ) {
    return getFriendsAndMessages(res.locals.cognitoId);
  }
}
