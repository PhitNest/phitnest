import { IRequest, IResponse } from "../../../common/types";
import { z } from "zod";
import { Controller, HttpMethod } from "../types";
import { authRepo } from "../../../domain/repositories";
import { IRefreshSessionEntity } from "../../../domain/entities";

export class RefreshSessionController
  implements Controller<IRefreshSessionEntity>
{
  method = HttpMethod.POST;

  route = "/auth/refreshSession";

  validator = z.object({
    email: z.string().trim(),
    refreshToken: z.string(),
  });

  execute(
    req: IRequest<z.infer<typeof this.validator>>,
    res: IResponse<IRefreshSessionEntity>
  ) {
    return authRepo.refreshSession(req.body.refreshToken, req.body.email);
  }
}
