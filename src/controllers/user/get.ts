import { AuthenticatedLocals, IRequest, IResponse } from "../../common/types";
import { z } from "zod";
import { Controller, HttpMethod } from "../types";
import { authMiddleware } from "../../middleware";
import { IGymEntity, IUserEntity } from "../../entities";
import { getUserPopulated } from "../../use-cases";

const getUser = z.object({
  allDevices: z.boolean(),
});

type GetUserRequest = z.infer<typeof getUser>;

type GetUserResponse = IUserEntity & {
  gym: IGymEntity;
};

export class GetUserController
  implements Controller<GetUserRequest, GetUserResponse, AuthenticatedLocals>
{
  method = HttpMethod.GET;

  middleware = [authMiddleware];

  validate(body: any) {
    return getUser.parse(body);
  }

  execute(
    req: IRequest<GetUserRequest>,
    res: IResponse<GetUserResponse, AuthenticatedLocals>
  ) {
    return getUserPopulated(res.locals.cognitoId);
  }
}
