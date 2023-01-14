import { AuthenticatedLocals, IRequest, IResponse } from "../../common/types";
import { Controller, HttpMethod } from "../types";
import { authMiddleware } from "../../middleware";
import { IGymEntity, IUserEntity } from "../../entities";
import { getUserPopulated } from "../../use-cases";

type GetUserResponse = IUserEntity & {
  gym: IGymEntity;
};

export class GetUserController
  implements Controller<{}, GetUserResponse, AuthenticatedLocals>
{
  method = HttpMethod.GET;

  middleware = [authMiddleware];

  validate(body: any) {
    return {};
  }

  execute(
    req: IRequest<{}>,
    res: IResponse<GetUserResponse, AuthenticatedLocals>
  ) {
    return getUserPopulated(res.locals.cognitoId);
  }
}
