import { injectable, inject } from "inversify";
import { z } from "zod";
import { UseCases } from "../../../common/dependency-injection";
import {
  IConfirmRegisterUseCase,
  ILoginUseCase,
  IRegisterUseCase,
} from "../../../use-cases/interfaces";
import { IRequest, IResponse } from "../../types";
import { IAuthController } from "../interfaces";

@injectable()
export class AuthController implements IAuthController {
  loginUseCase: ILoginUseCase;
  registerUseCase: IRegisterUseCase;
  confirmRegisterUseCase: IConfirmRegisterUseCase;

  constructor(
    @inject(UseCases.login) loginUseCase: ILoginUseCase,
    @inject(UseCases.register) registerUseCase: IRegisterUseCase,
    @inject(UseCases.confirmRegister)
    confirmRegisterUseCase: IConfirmRegisterUseCase
  ) {
    this.loginUseCase = loginUseCase;
    this.registerUseCase = registerUseCase;
    this.confirmRegisterUseCase = confirmRegisterUseCase;
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

  async register(req: IRequest, res: IResponse) {
    try {
      const { email, password, gymId, firstName, lastName } = z
        .object({
          email: z.string().email(),
          password: z.string(),
          gymId: z.string(),
          firstName: z.string().min(1),
          lastName: z.string().min(1),
        })
        .parse(req.content());
      await this.registerUseCase.execute(
        email,
        password,
        gymId,
        firstName,
        lastName
      );
      return res.status(201);
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

  async confirmRegister(req: IRequest, res: IResponse) {
    try {
      const { email, code } = z
        .object({
          email: z.string().email(),
          code: z.string(),
        })
        .parse(req.content());
      await this.confirmRegisterUseCase.execute(email, code);
      return res.status(200);
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
