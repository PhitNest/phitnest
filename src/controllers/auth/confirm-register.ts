import { IRequest, IResponse } from "../../common/types";
import { z } from "zod";
import { Controller, HttpMethod } from "../types";
import repositories from "../../repositories/injection";

const confirmRegister = z.object({
  email: z.string().trim().email(),
  code: z.string().min(6),
});

type ConfirmRegisterRequest = z.infer<typeof confirmRegister>;

export class ConfirmRegisterController
  implements Controller<ConfirmRegisterRequest, void>
{
  method = HttpMethod.POST;

  validate(body: any) {
    return confirmRegister.parse(body);
  }

  async execute(req: IRequest<ConfirmRegisterRequest>, res: IResponse<void>) {
    const { authRepo } = repositories();
    const result = await authRepo.confirmRegister(
      req.body.email,
      req.body.code
    );
    if (result) {
      return res.status(500).json(result);
    } else {
      return res.status(200).json();
    }
  }
}
