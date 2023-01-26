import {
  AuthenticatedLocals,
  IRequest,
  IResponse,
} from "../../../common/types";
import { Controller, HttpMethod } from "../types";
import { authMiddleware } from "../../middleware";
import {
  IGymEntity,
  IProfilePictureUserEntity,
} from "../../../domain/entities";
import { getUserPopulated } from "../../../domain/use-cases";

type GetUserResponse = IProfilePictureUserEntity & {
  gym: IGymEntity;
};

export class GetUserController implements Controller<GetUserResponse> {
  method = HttpMethod.GET;

  route = "/user";

  middleware = [authMiddleware];

  execute(req: IRequest, res: IResponse<GetUserResponse, AuthenticatedLocals>) {
    return getUserPopulated(res.locals.cognitoId);
  }
}
