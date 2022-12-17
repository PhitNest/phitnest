import { IAuthEntity } from "../../src/entities";
import { IAuthRepository } from "../../src/repositories/interfaces";

export class MockAuthRepo implements IAuthRepository {
  refreshSession(
    refreshToken: string,
    email: string
  ): Promise<Omit<IAuthEntity, "refreshToken">> {
    throw new Error("Method not implemented.");
  }
  deleteUser(cognitoId: string): Promise<void> {
    throw new Error("Method not implemented.");
  }
  signOut(cognitoId: string, allDevices: boolean): Promise<void> {
    throw new Error("Method not implemented.");
  }
  forgotPassword(email: string): Promise<void> {
    throw new Error("Method not implemented.");
  }
  forgotPasswordSubmit(
    email: string,
    code: string,
    newPassword: string
  ): Promise<void> {
    throw new Error("Method not implemented.");
  }
  confirmRegister(email: string, code: string): Promise<void> {
    throw new Error("Method not implemented.");
  }
  login(email: string, password: string): Promise<IAuthEntity> {
    throw new Error("Method not implemented.");
  }
  resendConfirmationCode(email: string): Promise<void> {
    throw new Error("Method not implemented.");
  }
  async getCognitoId(accessToken: string) {
    if (accessToken === "test") {
      return "cognitoId";
    } else {
      throw new Error("Invalid access token");
    }
  }

  async registerUser(email: string, password: string) {
    if (password.length < 8) {
      throw new Error("Password must be at least 8 characters");
    } else {
      return "cognitoId";
    }
  }
}
