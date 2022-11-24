export interface IAuthRepository {
  getUserId(accessToken: string): Promise<string | undefined>;
  refreshAccessToken(
    refreshToken: string,
    email: string
  ): Promise<string | undefined>;
  deleteUser(userId: string): Promise<boolean>;
  registerUser(email: string, password: string): Promise<string | undefined>;
  signOut(userId: string, allDevices: boolean): Promise<void>;
  forgotPassword(email: string): Promise<void>;
  forgotPasswordSubmit(
    email: string,
    code: string,
    password: string
  ): Promise<void>;
  confirmRegister(email: string, code: string): Promise<void>;
  login(email: string, password: string): Promise<string | undefined>;
  resendConfirmationCode(email: string): Promise<void>;
}
