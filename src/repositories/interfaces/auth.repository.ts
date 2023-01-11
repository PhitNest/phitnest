import { Either } from "typescript-monads";
import { kUserNotFound } from "../../common/failures";
import { Failure } from "../../common/types";
import { IAuthEntity, IRefreshSessionEntity } from "../../entities";

export interface IAuthRepository {
  getCognitoId(
    accessToken: string
  ): Promise<Either<typeof kUserNotFound, string>>;

  refreshSession(
    refreshToken: string,
    email: string
  ): Promise<Either<Failure, IRefreshSessionEntity>>;

  deleteUser(cognitoId: string): Promise<void | Failure>;

  registerUser(
    email: string,
    password: string
  ): Promise<Either<string, Failure>>;

  signOut(cognitoId: string, allDevices: boolean): Promise<void | Failure>;

  forgotPassword(email: string): Promise<void | Failure>;

  forgotPasswordSubmit(
    email: string,
    code: string,
    newPassword: string
  ): Promise<Either<null, Failure>>;

  confirmRegister(email: string, code: string): Promise<void | Failure>;

  login(email: string, password: string): Promise<Either<Failure, IAuthEntity>>;

  resendConfirmationCode(email: string): Promise<void | Failure>;
}
