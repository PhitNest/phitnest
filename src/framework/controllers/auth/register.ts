import { IRequest, IResponse } from "../../../common/types";
import { z } from "zod";
import { Controller, HttpMethod } from "../types";
import { registerUser } from "../../../domain/use-cases";
import { IUserEntity } from "../../../domain/entities";

const register = z.object({
  email: z.string().trim(),
  password: z.string().min(8),
  firstName: z.string().trim().min(1),
  lastName: z.string().trim().min(1),
  gymId: z.string().trim(),
});

type RegisterRequest = z.infer<typeof register>;
type RegisterResponse = IUserEntity & { uploadUrl: string };

export class RegisterController
  implements Controller<RegisterRequest, RegisterResponse>
{
  method = HttpMethod.POST;

  validate(body: any) {
    return register.parse(body);
  }

  execute(req: IRequest<RegisterRequest>, res: IResponse<RegisterResponse>) {
    return registerUser(req.body);
  }
}
