import { IAuthEntity } from "../../entities";

export interface IAuthRepository {
  getCognitoId(accessToken: string): Promise<string | null>;
  refreshAccessToken(
    refreshToken: string,
    cognitoId: string
  ): Promise<string | null>;
  deleteUser(cognitoId: string): Promise<boolean>;
  registerUser(email: string, password: string): Promise<string | null>;
  signOut(cognitoId: string, allDevices: boolean): Promise<boolean>;
  forgotPassword(email: string): Promise<boolean>;
  forgotPasswordSubmit(
    email: string,
    code: string,
    newPassword: string
  ): Promise<boolean>;
  confirmRegister(email: string, code: string): Promise<boolean>;
  login(email: string, password: string): Promise<IAuthEntity | null>;
  resendConfirmationCode(email: string): Promise<boolean>;
}
