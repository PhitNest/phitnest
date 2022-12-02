import { CognitoAuthRepository } from "../../src/repositories/implementations";

export class MockAuthRepo extends CognitoAuthRepository {
  async getCognitoId(accessToken: string): Promise<string | null> {
    return accessToken === "test" ? "cognitoId" : null;
  }

  async registerUser(email: string, password: string) {
    if (password.length < 8) {
      return null;
    } else {
      return "cognitoId";
    }
  }
}
