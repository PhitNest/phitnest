import { IRequest, IResponse } from "../../../common/types";
import { z } from "zod";
import { Controller, HttpMethod } from "../types";
import { IAuthEntity, IUserEntity } from "../../../domain/entities";
import { login } from "../../../domain/use-cases";

const validator = z.object({
  email: z.string().trim(),
  password: z.string().min(8),
});

type LoginRequest = z.infer<typeof validator>;
type LoginResponse = {
  session: IAuthEntity;
  user: IUserEntity;
};

export class LoginController
  implements Controller<LoginRequest, LoginResponse>
{
  method = HttpMethod.POST;

  validate(body: any) {
    return validator.parse(body);
  }

  execute(req: IRequest<LoginRequest>, res: IResponse<LoginResponse>) {
    return login(req.body.email, req.body.password);
  }
}
