import { IRequest, IResponse } from "../../common/types";
import { z } from "zod";
import { Controller, HttpMethod } from "../types";
import { authRepository } from "../../repositories/injection";

const register = z.object({
  email: z.string().trim().email(),
  password: z.string().min(8),
  firstName: z.string().trim().min(1),
  lastName: z.string().trim().min(1),
  gymId: z.string().trim(),
});

type RegisterRequest = z.infer<typeof register>;

export class RegisteerController implements Controller<RegisterRequest, void> {
  method = HttpMethod.POST;

  validate(body: any) {
    return register.parse(body);
  }

  async execute(req: IRequest<RegisterRequest>, res: IResponse<void>) {}
}
