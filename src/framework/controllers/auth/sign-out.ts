import {
  AuthenticatedLocals,
  IRequest,
  IResponse,
} from "../../../common/types";
import { z } from "zod";
import { Controller, HttpMethod } from "../types";
import { authRepo } from "../../../domain/repositories";
import { authMiddleware } from "../../middleware";
import { getSocketServer } from "../../adapters/injection";

const validator = z.object({
  allDevices: z.boolean(),
});

type SignOutRequest = z.infer<typeof validator>;

export class SignOutController
  implements Controller<SignOutRequest, void, AuthenticatedLocals>
{
  method = HttpMethod.POST;

  middleware = [authMiddleware];

  validate(body: any) {
    return validator.parse(body);
  }

  execute(
    req: IRequest<SignOutRequest>,
    res: IResponse<void, AuthenticatedLocals>
  ) {
    getSocketServer().kickUser(res.locals.cognitoId);
    return authRepo.signOut(req.authorization);
  }
}
