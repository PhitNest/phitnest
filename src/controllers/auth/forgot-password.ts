import { IRequest, IResponse } from "../../common/types";
import { z } from "zod";
import { Controller, HttpMethod } from "../types";
import repositories from "../../repositories/injection";

const forgotPassword = z.object({
  email: z.string().trim().email(),
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
    const { authRepo } = repositories();
    return authRepo.forgotPassword(req.body.email);
  }
}
