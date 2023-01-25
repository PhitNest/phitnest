import { IRequest, IResponse } from "../../../common/types";
import { z } from "zod";
import { Controller, HttpMethod } from "../types";
import { IUserEntity } from "../../../domain/entities";
import { confirmRegister } from "../../../domain/use-cases";

const validator = z.object({
  email: z.string().trim(),
  code: z.string().length(6),
});

type ConfirmRegisterRequest = z.infer<typeof validator>;

export class ConfirmRegisterController
  implements Controller<ConfirmRegisterRequest, IUserEntity>
{
  method = HttpMethod.POST;

  validate(body: any) {
    return validator.parse(body);
  }

  execute(req: IRequest<ConfirmRegisterRequest>, res: IResponse<IUserEntity>) {
    return confirmRegister(req.body.email, req.body.code);
  }
}
