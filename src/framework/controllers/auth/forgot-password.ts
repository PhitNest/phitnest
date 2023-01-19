import { IRequest, IResponse } from "../../../common/types";
import { z } from "zod";
import { Controller, HttpMethod } from "../types";
import { authRepo } from "../../../domain/repositories";

const forgotPassword = z.object({
  email: z.string().trim(),
});

type ForgotPasswordRequest = z.infer<typeof forgotPassword>;

export class ForgotPasswordController
  implements Controller<ForgotPasswordRequest, void>
{
  method = HttpMethod.POST;

  validate(body: any) {
    return forgotPassword.parse(body);
  }

  execute(req: IRequest<ForgotPasswordRequest>, res: IResponse<void>) {
    return authRepo.forgotPassword(req.body.email);
  }
}
