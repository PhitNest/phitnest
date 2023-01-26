import { IRequest, IResponse } from "../../../common/types";
import { z } from "zod";
import { Controller, HttpMethod } from "../types";
import { authRepo } from "../../../domain/repositories";

export class ForgotPasswordSubmitController implements Controller<void> {
  method = HttpMethod.POST;

  route = "/auth/forgotPasswordSubmit";

  validator = z.object({
    email: z.string().trim(),
    code: z.string().length(6),
    newPassword: z.string().min(8),
  });

  execute(req: IRequest<z.infer<typeof this.validator>>, res: IResponse<void>) {
    return authRepo.forgotPasswordSubmit(
      req.body.email,
      req.body.code,
      req.body.newPassword
    );
  }
}
