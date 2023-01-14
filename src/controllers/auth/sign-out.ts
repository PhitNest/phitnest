import { AuthenticatedLocals, IRequest, IResponse } from "../../common/types";
import { z } from "zod";
import { Controller, HttpMethod } from "../types";
import repositories from "../../repositories/injection";
import { authMiddleware } from "../../middleware";
import { getSocketServer } from "../../adapters/injection";

const signOut = z.object({
  allDevices: z.boolean(),
});

type SignOutRequest = z.infer<typeof signOut>;

export class SignOutController
  implements Controller<SignOutRequest, void, AuthenticatedLocals>
{
  method = HttpMethod.POST;

  middleware = [authMiddleware];

  validate(body: any) {
    return signOut.parse(body);
  }

  execute(
    req: IRequest<SignOutRequest>,
    res: IResponse<void, AuthenticatedLocals>
  ) {
    const { authRepo } = repositories();
    getSocketServer().kickUser(res.locals.cognitoId);
    return authRepo.signOut(res.locals.cognitoId, req.body.allDevices);
  }
}
