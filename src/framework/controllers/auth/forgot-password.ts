import { IRequest, IResponse } from "../../../common/types";
import { z } from "zod";
import { Controller, HttpMethod } from "../types";
import { forgotPassword } from "../../../domain/use-cases";

const forgotPasswordValidator = z.object({
  email: z.string().trim(),
});

type ForgotPasswordRequest = z.infer<typeof forgotPasswordValidator>;

export class ForgotPasswordController
  implements Controller<ForgotPasswordRequest, void>
{
  method = HttpMethod.POST;

  validate(body: any) {
    return forgotPasswordValidator.parse(body);
  }

  execute(req: IRequest<ForgotPasswordRequest>, res: IResponse<void>) {
    return forgotPassword(req.body.email);
  }
}
