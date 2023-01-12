import { Failure, IRequest, IResponse } from "../../common/types";
import { z } from "zod";
import { Controller, HttpMethod } from "../types";
import { IAuthEntity } from "../../entities";
import repositories from "../../repositories/injection";

const login = z.object({
  email: z.string().trim().email(),
  password: z.string().min(8),
});

type LoginRequest = z.infer<typeof login>;

export class LoginController implements Controller<LoginRequest, IAuthEntity> {
  method = HttpMethod.POST;

  validate(body: any) {
    return login.parse(body);
  }

  async execute(req: IRequest<LoginRequest>, res: IResponse<IAuthEntity>) {
    const { authRepo } = repositories();
    const result = await authRepo.login(req.body.email, req.body.password);
    if (result instanceof Failure) {
      return res.status(500).json(result);
    } else {
      return res.status(200).json(result);
    }
  }
}
