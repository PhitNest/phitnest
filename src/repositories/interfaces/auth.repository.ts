import { IAuthEntity } from "../../entities";

export interface IAuthRepository {
  getCognitoId(accessToken: string): Promise<string>;
  refreshSession(
    refreshToken: string,
    cognitoId: string
  ): Promise<Omit<IAuthEntity, "refreshToken">>;
  deleteUser(cognitoId: string): Promise<void>;
  registerUser(email: string, password: string): Promise<string>;
  signOut(cognitoId: string, allDevices: boolean): Promise<void>;
  forgotPassword(email: string): Promise<void>;
  forgotPasswordSubmit(
    email: string,
    code: string,
    newPassword: string
  ): Promise<void>;
  confirmRegister(email: string, code: string): Promise<void>;
  login(email: string, password: string): Promise<IAuthEntity>;
  resendConfirmationCode(email: string): Promise<void>;
}
