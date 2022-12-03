import { CognitoAuthRepository } from "../../src/repositories/implementations";

export class MockAuthRepo extends CognitoAuthRepository {
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
