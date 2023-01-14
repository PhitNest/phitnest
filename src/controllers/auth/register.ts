import { IRequest, IResponse } from "../../common/types";
import { z } from "zod";
import { Controller, HttpMethod } from "../types";
import { registerUser } from "../../use-cases";
import { IProfilePictureUserEntity } from "../../entities";

const register = z.object({
  email: z.string().trim().email(),
  password: z.string().min(8),
  firstName: z.string().trim().min(1),
  lastName: z.string().trim().min(1),
  gymId: z.string().trim(),
});

type RegisterRequest = z.infer<typeof register>;

export class RegisterController
  implements Controller<RegisterRequest, IProfilePictureUserEntity>
{
  method = HttpMethod.POST;

  validate(body: any) {
    return register.parse(body);
  }

  execute(
    req: IRequest<RegisterRequest>,
    res: IResponse<IProfilePictureUserEntity>
  ) {
    return registerUser(req.body);
  }
}
