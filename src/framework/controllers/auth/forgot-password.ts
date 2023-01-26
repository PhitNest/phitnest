import { IRequest, IResponse } from "../../../common/types";
import { z } from "zod";
import { Controller, HttpMethod } from "../types";
import { forgotPassword } from "../../../domain/use-cases";

export class ForgotPasswordController implements Controller<void> {
  method = HttpMethod.POST;

  route = "/auth/forgotPassword";

  validator = z.object({
    email: z.string().trim(),
  });

  execute(req: IRequest<z.infer<typeof this.validator>>, res: IResponse<void>) {
    return forgotPassword(req.body.email);
  }
}
