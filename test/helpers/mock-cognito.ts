import { randomUUID } from "crypto";
import { kUserNotFound } from "../../src/common/failures";
import { Failure } from "../../src/common/types";
import { IAuthRepository } from "../../src/repositories/interfaces";

export class MockAuthRepository implements IAuthRepository {
  async getCognitoId(accessToken: string) {
    if (accessToken == "invalid") {
      return kUserNotFound;
    } else {
      return accessToken.repeat(2);
    }
  }

  async refreshSession(refreshToken: string, email: string) {
    return {
      accessToken: refreshToken.repeat(2),
      idToken: refreshToken.repeat(2),
    };
  }

  async deleteUser(cognitoId: string) {}

  async registerUser(email: string, password: string) {
    if (email == "invalid") {
      return kUserNotFound;
    } else {
      return randomUUID();
    }
  }

  async signOut(cognitoId: string, allDevices: boolean) {}

  async forgotPassword(email: string) {}

  async forgotPasswordSubmit(
    email: string,
    code: string,
    newPassword: string
  ) {}

  async confirmRegister(email: string, code: string) {
    if (email == "invalid") {
      return kUserNotFound;
    }
  }

  async login(email: string, password: string) {
    if (email == "invalid") {
      return kUserNotFound;
    } else {
      return {
        accessToken: randomUUID(),
        idToken: randomUUID(),
        refreshToken: randomUUID(),
      };
    }
  }

  async resendConfirmationCode(email: string) {}
}
