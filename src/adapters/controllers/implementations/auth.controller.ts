import { injectable, inject } from "inversify";
import { z } from "zod";
import { UseCases } from "../../../common/dependency-injection";
import { ILoginUseCase } from "../../../use-cases/interfaces";
import { IRequest, IResponse } from "../../types";
import { IAuthController } from "../interfaces";

@injectable()
export class AuthController implements IAuthController {
  loginUseCase: ILoginUseCase;

  constructor(@inject(UseCases.login) loginUseCase: ILoginUseCase) {
    this.loginUseCase = loginUseCase;
  }

  async login(req: IRequest, res: IResponse) {
    try {
      const { email, password } = z
        .object({
          email: z.string().email(),
          password: z.string(),
        })
        .parse(req.content());
      const userId = await this.loginUseCase.execute(email, password);
      return res.status(200).json({ _id: userId });
    } catch (err) {
      if (err instanceof z.ZodError) {
        return res.status(400).json(err.issues);
      } else if (err instanceof Error) {
        return res.status(500).json({ message: err.message });
      } else {
        return res.status(500).json(err);
      }
    }
  }
}
