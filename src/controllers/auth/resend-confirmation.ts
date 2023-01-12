import { IRequest, IResponse } from "../../common/types";
import { z } from "zod";
import { Controller, HttpMethod } from "../types";
import repositories from "../../repositories/injection";

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

  async execute(
    req: IRequest<ResendConfirmationRequest>,
    res: IResponse<void>
  ) {
    const { authRepo } = repositories();
    const result = await authRepo.resendConfirmationCode(req.body.email);
    if (result) {
      return res.status(500).json(result);
    } else {
      return res.status(200).json();
    }
  }
}
