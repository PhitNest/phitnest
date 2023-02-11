import {
  AuthenticatedLocals,
  IRequest,
  IResponse,
} from "../../../common/types";
import { z } from "zod";
import { Controller, HttpMethod } from "../types";
import databases from "../../../data/data-sources/injection";
import { authMiddleware } from "../../middleware";
import { getSocketServer } from "../../adapters/injection";

export class SignOutController implements Controller<void> {
  method = HttpMethod.POST;

  route = "/auth/signOut";

  validator = z.object({
    allDevices: z.boolean(),
  });

  middleware = [authMiddleware];

  execute(
    req: IRequest<z.infer<typeof this.validator>>,
    res: IResponse<void, AuthenticatedLocals>
  ) {
    getSocketServer().kickUser(res.locals.cognitoId);
    return databases().authDatabase.signOut(req.authorization);
  }
}
