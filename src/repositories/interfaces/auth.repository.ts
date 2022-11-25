export interface IAuthRepository {
  getCognitoId(accessToken: string): Promise<string | null>;
  refreshAccessToken(
    refreshToken: string,
    email: string
  ): Promise<string | null>;
  deleteUser(cognitoId: string): Promise<boolean>;
  registerUser(email: string, password: string): Promise<string | null>;
  signOut(cognitoId: string, allDevices: boolean): Promise<void>;
  forgotPassword(email: string): Promise<void>;
  forgotPasswordSubmit(
    email: string,
    code: string,
    password: string
  ): Promise<void>;
  confirmRegister(email: string, code: string): Promise<void>;
  login(email: string, password: string): Promise<string | null>;
  resendConfirmationCode(email: string): Promise<void>;
}
