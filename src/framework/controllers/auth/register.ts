import { IRequest, IResponse } from "../../../common/types";
import { z } from "zod";
import { Controller, HttpMethod } from "../types";
import { registerUser } from "../../../domain/use-cases";
import { IUserEntity } from "../../../domain/entities";

type RegisterResponse = { user: IUserEntity; uploadUrl: string };

export class RegisterController implements Controller<RegisterResponse> {
  method = HttpMethod.POST;

  route = "/auth/register";

  validator = z.object({
    email: z.string().trim(),
    password: z.string().min(8),
    firstName: z.string().trim().min(1),
    lastName: z.string().trim().min(1),
    gymId: z.string().trim(),
  });

  execute(
    req: IRequest<z.infer<typeof this.validator>>,
    res: IResponse<RegisterResponse>
  ) {
    return registerUser(req.body);
  }
}
