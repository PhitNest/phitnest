import { injectable, inject } from "inversify";
import { z } from "zod";
import { UseCases } from "../../../common/dependency-injection";
import {
  statusCreated,
  statusInternalServerError,
  statusOK,
} from "../../../constants/http_codes";
import { IAuthEntity } from "../../../entities";
import {
  IConfirmRegisterUseCase,
  IForgotPasswordSubmitUseCase,
  IForgotPasswordUseCase,
  IGetUploadProfilePictureURLUseCase,
  IGetUserByEmailUseCase,
  ILoginUseCase,
  IRefreshSessionUseCase,
  IRegisterUseCase,
  IResendConfirmationUseCase,
  ISignOutUseCase,
} from "../../../use-cases/interfaces";
import { IAuthenticatedResponse, IRequest, IResponse } from "../../types";
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
  getUploadProfilePictureURLUseCase: IGetUploadProfilePictureURLUseCase;
  getUserByEmailUseCase: IGetUserByEmailUseCase;

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
    @inject(UseCases.signOut) signOutUseCase: ISignOutUseCase,
    @inject(UseCases.getUploadProfilePictureURL)
    getUploadProfilePictureURLUseCase: IGetUploadProfilePictureURLUseCase,
    @inject(UseCases.getUserByEmail)
    getUserByEmailUseCase: IGetUserByEmailUseCase
  ) {
    this.loginUseCase = loginUseCase;
    this.registerUseCase = registerUseCase;
    this.confirmRegisterUseCase = confirmRegisterUseCase;
    this.refreshSessionUseCase = refreshSessionUseCase;
    this.resendConfirmationUseCase = resendConfirmationUseCase;
    this.forgotPasswordUseCase = forgotPasswordUseCase;
    this.forgotPasswordSubmitUseCase = forgotPasswordSubmitUseCase;
    this.signOutUseCase = signOutUseCase;
    this.getUploadProfilePictureURLUseCase = getUploadProfilePictureURLUseCase;
    this.getUserByEmailUseCase = getUserByEmailUseCase;
  }

  async signOut(req: IRequest, res: IAuthenticatedResponse) {
    try {
      const { allDevices } = z
        .object({ allDevices: z.boolean() })
        .parse(req.content());
      await this.signOutUseCase.execute(res.locals.cognitoId, allDevices);
      return res.status(statusOK).send();
    } catch (err) {
      return res.status(statusInternalServerError).send(err);
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
      return res.status(statusInternalServerError).send(err);
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
      return res.status(statusInternalServerError).send(err);
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
      return res.status(statusInternalServerError).send(err);
    }
  }

  async login(req: IRequest, res: IResponse<IAuthEntity>) {
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
      return res.status(statusInternalServerError).send(err);
    }
  }

  async register(
    req: IRequest,
    res: IResponse<{ uploadProfilePicture: string }>
  ) {
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
      return res.status(statusCreated).json({
        uploadProfilePicture: await this.registerUseCase.execute(
          email,
          password,
          gymId,
          firstName,
          lastName
        ),
      });
    } catch (err) {
      return res.status(statusInternalServerError).send(err);
    }
  }

  async getUploadProfilePictureUrlUnconfirmed(
    req: IRequest,
    res: IResponse<{ uploadProfilePicture: string }>
  ) {
    try {
      const { email, cognitoId } = z
        .object({
          email: z.string().trim().email(),
          cognitoId: z.string().trim(),
        })
        .parse(req.content());
      const user = await this.getUserByEmailUseCase.execute(email);
      if (user.confirmed) {
        return res
          .status(statusInternalServerError)
          .send("User already confirmed");
      } else {
        return res.status(statusOK).json({
          uploadProfilePicture:
            await this.getUploadProfilePictureURLUseCase.execute(cognitoId),
        });
      }
    } catch (err) {
      return res.status(statusInternalServerError).send(err);
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
      return res.status(statusInternalServerError).send(err);
    }
  }

  async refreshSession(
    req: IRequest,
    res: IResponse<Omit<IAuthEntity, "refreshToken">>
  ) {
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
      return res.status(statusInternalServerError).send(err);
    }
  }
}
