import { IRequest, IResponse } from "../../../common/types";
import { z } from "zod";
import { Controller, HttpMethod } from "../types";
import { authRepo } from "../../../domain/repositories";

const validator = z.object({
  email: z.string().trim(),
});

type ResendConfirmationRequest = z.infer<typeof validator>;

export class ResendConfirmationController
  implements Controller<ResendConfirmationRequest, void>
{
  method = HttpMethod.POST;

  validate(body: any) {
    return validator.parse(body);
  }

  execute(req: IRequest<ResendConfirmationRequest>, res: IResponse<void>) {
    return authRepo.resendConfirmationCode(req.body.email);
  }
}
