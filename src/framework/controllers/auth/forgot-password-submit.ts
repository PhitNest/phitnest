import { IRequest, IResponse } from "../../../common/types";
import { z } from "zod";
import { Controller, HttpMethod } from "../types";
import { authRepo } from "../../../domain/repositories";

const forgotPasswordSubmit = z.object({
  email: z.string().trim(),
  code: z.string().length(6),
  newPassword: z.string().min(8),
});

type ForgotPasswordSubmitRequest = z.infer<typeof forgotPasswordSubmit>;

export class ForgotPasswordSubmitController
  implements Controller<ForgotPasswordSubmitRequest, void>
{
  method = HttpMethod.POST;

  validate(body: any) {
    return forgotPasswordSubmit.parse(body);
  }

  execute(req: IRequest<ForgotPasswordSubmitRequest>, res: IResponse<void>) {
    return authRepo.forgotPasswordSubmit(
      req.body.email,
      req.body.code,
      req.body.newPassword
    );
  }
}
