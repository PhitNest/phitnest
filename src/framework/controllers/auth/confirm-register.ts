import { IRequest, IResponse } from "../../../common/types";
import { z } from "zod";
import { Controller, HttpMethod } from "../types";
import { confirmRegister } from "../../../domain/use-cases";
import { IProfilePictureUserEntity } from "../../../domain/entities";

export class ConfirmRegisterController
  implements Controller<IProfilePictureUserEntity>
{
  method = HttpMethod.POST;

  route = "/auth/confirmRegister";

  validator = z.object({
    email: z.string().trim(),
    code: z.string().length(6),
  });

  execute(
    req: IRequest<z.infer<typeof this.validator>>,
    res: IResponse<IProfilePictureUserEntity>
  ) {
    return confirmRegister(req.body.email, req.body.code);
  }
}
