import { IRequest, IResponse } from "../../../common/types";
import { z } from "zod";
import { Controller, HttpMethod } from "../types";
import { forgotPassword } from "../../../domain/use-cases";

const validator = z.object({
  email: z.string().trim(),
});

type ForgotPasswordRequest = z.infer<typeof validator>;

export class ForgotPasswordController
  implements Controller<ForgotPasswordRequest, void>
{
  method = HttpMethod.POST;

  validate(body: any) {
    return validator.parse(body);
  }

  execute(req: IRequest<ForgotPasswordRequest>, res: IResponse<void>) {
    return forgotPassword(req.body.email);
  }
}
