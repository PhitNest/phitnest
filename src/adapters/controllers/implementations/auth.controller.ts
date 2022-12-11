import { injectable, inject } from "inversify";
import { z } from "zod";
import { UseCases } from "../../../common/dependency-injection";
import {
  statusBadRequest,
  statusCreated,
  statusInternalServerError,
  statusOK,
} from "../../../constants/status_codes";
import {
  IConfirmRegisterUseCase,
  IForgotPasswordSubmitUseCase,
  IForgotPasswordUseCase,
  ILoginUseCase,
  IRefreshSessionUseCase,
  IRegisterUseCase,
  IResendConfirmationUseCase,
  ISignOutUseCase,
} from "../../../use-cases/interfaces";
import { AuthenticatedLocals, IRequest, IResponse } from "../../types";
import { IAuthController } from "../interfaces";

@injectable()
export class AuthController implements IAuthController {
  loginUseCase: ILoginUseCase;
  registerUseCase: IRegisterUseCase;
  confirmRegisterUseCase: IConfirmRegisterUseCase;
  refreshSessionUseCase: IRefreshSessionUseCase;
  resendConfirmationUseCase: IResendConfirmationUseCase;
  forgotPasswordUseCase: IForgotPasswordUseCase;
  signOutUseCase: ISignOutUseCase;
  forgotPasswordSubmitUseCase: IForgotPasswordSubmitUseCase;

  constructor(
    @inject(UseCases.login) loginUseCase: ILoginUseCase,
    @inject(UseCases.register) registerUseCase: IRegisterUseCase,
    @inject(UseCases.confirmRegister)
    confirmRegisterUseCase: IConfirmRegisterUseCase,
    @inject(UseCases.refreshSession)
    refreshSessionUseCase: IRefreshSessionUseCase,
    @inject(UseCases.resendConfirmation)
    resendConfirmationUseCase: IResendConfirmationUseCase,
    @inject(UseCases.forgotPassword)
    forgotPasswordUseCase: IForgotPasswordUseCase,
    @inject(UseCases.forgotPasswordSubmit)
    forgotPasswordSubmitUseCase: IForgotPasswordSubmitUseCase,
    @inject(UseCases.signOut) signOutUseCase: ISignOutUseCase
  ) {
    this.loginUseCase = loginUseCase;
    this.registerUseCase = registerUseCase;
    this.confirmRegisterUseCase = confirmRegisterUseCase;
    this.refreshSessionUseCase = refreshSessionUseCase;
    this.resendConfirmationUseCase = resendConfirmationUseCase;
    this.forgotPasswordUseCase = forgotPasswordUseCase;
    this.forgotPasswordSubmitUseCase = forgotPasswordSubmitUseCase;
    this.signOutUseCase = signOutUseCase;
  }

  async signOut(req: IRequest, res: IResponse<AuthenticatedLocals>) {
    try {
      const { allDevices } = z
        .object({ allDevices: z.boolean() })
        .parse(req.content());
      await this.signOutUseCase.execute(res.locals.cognitoId, allDevices);
      return res.status(statusOK).send();
    } catch (err) {
      if (err instanceof z.ZodError) {
        return res.status(statusBadRequest).json(err.issues);
      } else if (err instanceof Error) {
        return res.status(statusInternalServerError).json(err.message);
      } else {
        return res.status(statusInternalServerError).send(err);
      }
    }
  }

  async forgotPasswordSubmit(req: IRequest, res: IResponse) {
    try {
      const { email, code, newPassword } = z
        .object({
          email: z.string().email().trim(),
          code: z.string(),
          newPassword: z.string(),
        })
        .parse(req.content());
      await this.forgotPasswordSubmitUseCase.execute(email, code, newPassword);
      return res.status(statusOK).send();
    } catch (err) {
      if (err instanceof z.ZodError) {
        return res.status(statusBadRequest).json(err.issues);
      } else if (err instanceof Error) {
        return res.status(statusInternalServerError).json(err.message);
      } else {
        return res.status(statusInternalServerError).send(err);
      }
    }
  }

  async forgotPassword(req: IRequest, res: IResponse) {
    try {
      const { email } = z
        .object({ email: z.string().trim().email() })
        .parse(req.content());
      await this.forgotPasswordUseCase.execute(email);
      return res.status(statusOK).send();
    } catch (err) {
      if (err instanceof z.ZodError) {
        return res.status(statusBadRequest).json(err.issues);
      } else if (err instanceof Error) {
        return res.status(statusInternalServerError).json(err.message);
      } else {
        return res.status(statusInternalServerError).send(err);
      }
    }
  }

  async resendConfirmation(req: IRequest, res: IResponse) {
    try {
      const { email } = z
        .object({ email: z.string().trim().email() })
        .parse(req.content());
      await this.resendConfirmationUseCase.execute(email);
      return res.status(statusOK).send();
    } catch (err) {
      if (err instanceof z.ZodError) {
        return res.status(statusBadRequest).json(err.issues);
      } else if (err instanceof Error) {
        return res.status(statusInternalServerError).json(err.message);
      } else {
        return res.status(statusInternalServerError).send(err);
      }
    }
  }

  async login(req: IRequest, res: IResponse) {
    try {
      const { email, password } = z
        .object({
          email: z.string().trim().email(),
          password: z.string(),
        })
        .parse(req.content());
      const tokens = await this.loginUseCase.execute(email, password);
      return res.status(statusOK).json(tokens);
    } catch (err) {
      if (err instanceof z.ZodError) {
        return res.status(statusBadRequest).json(err.issues);
      } else if (err instanceof Error) {
        return res.status(statusInternalServerError).json(err.message);
      } else {
        return res.status(statusInternalServerError).send(err);
      }
    }
  }

  async register(req: IRequest, res: IResponse) {
    try {
      const { email, password, gymId, firstName, lastName } = z
        .object({
          email: z.string().trim().email(),
          password: z.string(),
          gymId: z.string(),
          firstName: z.string().trim().min(1),
          lastName: z.string().trim().min(1),
        })
        .parse(req.content());
      await this.registerUseCase.execute(
        email,
        password,
        gymId,
        firstName,
        lastName
      );
      return res.status(statusCreated).send();
    } catch (err) {
      if (err instanceof z.ZodError) {
        return res.status(statusBadRequest).json(err.issues);
      } else if (err instanceof Error) {
        return res.status(statusInternalServerError).json(err.message);
      } else {
        return res.status(statusInternalServerError).send(err);
      }
    }
  }

  async confirmRegister(req: IRequest, res: IResponse) {
    try {
      const { email, code } = z
        .object({
          email: z.string().trim().email(),
          code: z.string(),
        })
        .parse(req.content());
      await this.confirmRegisterUseCase.execute(email, code);
      return res.status(statusOK).send();
    } catch (err) {
      if (err instanceof z.ZodError) {
        return res.status(statusBadRequest).json(err.issues);
      } else if (err instanceof Error) {
        return res.status(statusInternalServerError).json(err.message);
      } else {
        return res.status(statusInternalServerError).send(err);
      }
    }
  }

  async refreshSession(req: IRequest, res: IResponse) {
    try {
      const { refreshToken, email } = z
        .object({
          refreshToken: z.string(),
          email: z.string().trim(),
        })
        .parse(req.content());
      const tokens = await this.refreshSessionUseCase.execute(
        refreshToken,
        email
      );
      return res.status(statusOK).json(tokens);
    } catch (err) {
      if (err instanceof z.ZodError) {
        return res.status(statusBadRequest).json(err.issues);
      } else if (err instanceof Error) {
        return res.status(statusInternalServerError).json(err.message);
      } else {
        return res.status(statusInternalServerError).send(err);
      }
    }
  }
}
