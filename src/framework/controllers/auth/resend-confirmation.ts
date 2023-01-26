import { IRequest, IResponse } from "../../../common/types";
import { z } from "zod";
import { Controller, HttpMethod } from "../types";
import { authRepo } from "../../../domain/repositories";

export class ResendConfirmationController implements Controller<void> {
  method = HttpMethod.POST;

  route = "/auth/resendConfirmation";

  validator = z.object({
    email: z.string().trim(),
  });

  execute(req: IRequest<z.infer<typeof this.validator>>, res: IResponse<void>) {
    return authRepo.resendConfirmationCode(req.body.email);
  }
}
