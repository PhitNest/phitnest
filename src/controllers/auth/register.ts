import { Failure, IRequest, IResponse } from "../../common/types";
import { z } from "zod";
import { Controller, HttpMethod } from "../types";
import { registerUser } from "../../use-cases";
import { IUserEntity } from "../../entities";

const register = z.object({
  email: z.string().trim().email(),
  password: z.string().min(8),
  firstName: z.string().trim().min(1),
  lastName: z.string().trim().min(1),
  gymId: z.string().trim(),
});

type RegisterRequest = z.infer<typeof register>;

export class RegisterController
  implements Controller<RegisterRequest, IUserEntity>
{
  method = HttpMethod.POST;

  validate(body: any) {
    return register.parse(body);
  }

  async execute(req: IRequest<RegisterRequest>, res: IResponse<IUserEntity>) {
    const registration = await registerUser(req.body);
    if (registration instanceof Failure) {
      return res.status(500).json(registration);
    } else {
      return res.status(200).json(registration);
    }
  }
}
