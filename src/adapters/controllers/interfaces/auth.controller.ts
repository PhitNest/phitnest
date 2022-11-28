import { AuthenticatedLocals, Controller } from "../../types";

export interface IAuthController {
  login: Controller;
  register: Controller;
  confirmRegister: Controller;
  refreshSession: Controller;
  resendConfirmation: Controller;
  forgotPassword: Controller;
  forgotPasswordSubmit: Controller;
  signOut: Controller<AuthenticatedLocals>;
}
