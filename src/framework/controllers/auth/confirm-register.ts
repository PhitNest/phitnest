import { IRequest, IResponse } from "../../../common/types";
import { z } from "zod";
import { Controller, HttpMethod } from "../types";
import { IUserEntity } from "../../../domain/entities";
import { confirmRegister } from "../../../domain/use-cases";

export class ConfirmRegisterController implements Controller<IUserEntity> {
  method = HttpMethod.POST;

  route = "/auth/confirmRegister";

  validator = z.object({
    email: z.string().trim(),
    code: z.string().length(6),
  });

  execute(
    req: IRequest<z.infer<typeof this.validator>>,
    res: IResponse<IUserEntity>
  ) {
    return confirmRegister(req.body.email, req.body.code);
  }
}
