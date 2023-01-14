import { kUserNotFound } from "../../common/failures";
import { Failure } from "../../common/types";
import { IAuthEntity, IRefreshSessionEntity } from "../../entities";

export interface IAuthRepository {
  getCognitoId(accessToken: string): Promise<string | Failure>;

  refreshSession(
    refreshToken: string,
    email: string
  ): Promise<IRefreshSessionEntity | Failure>;

  deleteUser(cognitoId: string): Promise<void | Failure>;

  registerUser(email: string, password: string): Promise<string | Failure>;

  signOut(accessToken: string): Promise<void | Failure>;

  forgotPassword(email: string): Promise<void | Failure>;

  forgotPasswordSubmit(
    email: string,
    code: string,
    newPassword: string
  ): Promise<void | Failure>;

  confirmRegister(email: string, code: string): Promise<void | Failure>;

  login(email: string, password: string): Promise<IAuthEntity | Failure>;

  resendConfirmationCode(email: string): Promise<void | Failure>;
}
