import { IRequest, IResponse } from "../../../common/types";
import { z } from "zod";
import { Controller, HttpMethod } from "../types";
import { confirmRegister } from "../../../domain/use-cases";

export class ConfirmRegisterController implements Controller<void> {
  method = HttpMethod.POST;

  route = "/auth/confirmRegister";

  validator = z.object({
    email: z.string().trim(),
    code: z.string().length(6),
  });

  execute(req: IRequest<z.infer<typeof this.validator>>, res: IResponse<void>) {
    return confirmRegister(req.body.email, req.body.code);
  }
}
