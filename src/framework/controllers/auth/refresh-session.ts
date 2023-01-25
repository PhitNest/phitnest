import { IRequest, IResponse } from "../../../common/types";
import { z } from "zod";
import { Controller, HttpMethod } from "../types";
import { authRepo } from "../../../domain/repositories";
import { IRefreshSessionEntity } from "../../../domain/entities";

const validator = z.object({
  email: z.string().trim(),
  refreshToken: z.string(),
});

type RefreshSessionRequest = z.infer<typeof validator>;

export class RefreshSessionController
  implements Controller<RefreshSessionRequest, IRefreshSessionEntity>
{
  method = HttpMethod.POST;

  validate(body: any) {
    return validator.parse(body);
  }

  execute(
    req: IRequest<RefreshSessionRequest>,
    res: IResponse<IRefreshSessionEntity>
  ) {
    return authRepo.refreshSession(req.body.refreshToken, req.body.email);
  }
}
