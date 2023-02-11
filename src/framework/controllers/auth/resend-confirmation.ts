import { IRequest, IResponse } from "../../../common/types";
import { z } from "zod";
import { Controller, HttpMethod } from "../types";
import databases from "../../../data/data-sources/injection";

export class ResendConfirmationController implements Controller<void> {
  method = HttpMethod.POST;

  route = "/auth/resendConfirmation";

  validator = z.object({
    email: z.string().trim(),
  });

  execute(req: IRequest<z.infer<typeof this.validator>>, res: IResponse<void>) {
    return databases().authDatabase.resendConfirmationCode(req.body.email);
  }
}
