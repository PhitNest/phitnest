import { IAuthEntity } from "../../../entities";
import { AuthenticatedController, Controller } from "../../types";

export interface IAuthController {
  login: Controller<IAuthEntity>;
  register: Controller<{ uploadProfilePicture: string }>;
  confirmRegister: Controller;
  refreshSession: Controller<Omit<IAuthEntity, "refreshToken">>;
  resendConfirmation: Controller;
  forgotPassword: Controller;
  forgotPasswordSubmit: Controller;
  signOut: AuthenticatedController;
  getUploadProfilePictureUrlUnconfirmed: Controller<{
    uploadProfilePicture: string;
  }>;
}
