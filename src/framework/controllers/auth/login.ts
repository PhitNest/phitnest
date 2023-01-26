import { IRequest, IResponse } from "../../../common/types";
import { z } from "zod";
import { Controller, HttpMethod } from "../types";
import { IAuthEntity, IUserEntity } from "../../../domain/entities";
import { login } from "../../../domain/use-cases";

type LoginResponse = {
  session: IAuthEntity;
  user: IUserEntity;
};

export class LoginController implements Controller<LoginResponse> {
  method = HttpMethod.POST;

  route = "/auth/login";

  validator = z.object({
    email: z.string().trim(),
    password: z.string().min(8),
  });

  execute(
    req: IRequest<z.infer<typeof this.validator>>,
    res: IResponse<LoginResponse>
  ) {
    return login(req.body.email, req.body.password);
  }
}
