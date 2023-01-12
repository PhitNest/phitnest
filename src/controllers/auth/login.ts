import { IRequest, IResponse } from "../../common/types";
import { z } from "zod";
import { Controller, HttpMethod } from "../types";
import { IAuthEntity, IUserEntity } from "../../entities";
import { login } from "../../use-cases";

const loginValidator = z.object({
  email: z.string().trim().email(),
  password: z.string().min(8),
});

type LoginRequest = z.infer<typeof loginValidator>;
type LoginResponse = {
  session: IAuthEntity;
  user: IUserEntity;
};

export class LoginController
  implements Controller<LoginRequest, LoginResponse>
{
  method = HttpMethod.POST;

  validate(body: any) {
    return loginValidator.parse(body);
  }

  execute(req: IRequest<LoginRequest>, res: IResponse<LoginResponse>) {
    return login(req.body.email, req.body.password);
  }
}
