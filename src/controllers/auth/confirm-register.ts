import { IRequest, IResponse } from "../../common/types";
import { z } from "zod";
import { Controller, HttpMethod } from "../types";
import { IUserEntity } from "../../entities";
import { confirmRegister } from "../../use-cases";

const confirmRegisterValidator = z.object({
  email: z.string().trim().email(),
  code: z.string().length(6),
});

type ConfirmRegisterRequest = z.infer<typeof confirmRegisterValidator>;

export class ConfirmRegisterController
  implements Controller<ConfirmRegisterRequest, IUserEntity>
{
  method = HttpMethod.POST;

  validate(body: any) {
    return confirmRegisterValidator.parse(body);
  }

  execute(req: IRequest<ConfirmRegisterRequest>, res: IResponse<IUserEntity>) {
    return confirmRegister(req.body.email, req.body.code);
  }
}
