import { IRequest, IResponse } from "../../../common/types";
import { z } from "zod";
import { Controller, HttpMethod } from "../types";
import { authRepo } from "../../../domain/repositories";

const resendConfirmation = z.object({
  email: z.string().trim().email(),
});

type ResendConfirmationRequest = z.infer<typeof resendConfirmation>;

export class ResendConfirmationController
  implements Controller<ResendConfirmationRequest, void>
{
  method = HttpMethod.POST;

  validate(body: any) {
    return resendConfirmation.parse(body);
  }

  execute(req: IRequest<ResendConfirmationRequest>, res: IResponse<void>) {
    return authRepo.resendConfirmationCode(req.body.email);
  }
}
