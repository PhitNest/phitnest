import { inject, injectable } from "inversify";
import { Repositories } from "../../common/dependency-injection";
import { IAuthRepository } from "../../repositories/interfaces";

@injectable()
export class RefreshSessionUseCase {
  authRepo: IAuthRepository;

  constructor(@inject(Repositories.auth) authRepo: IAuthRepository) {
    this.authRepo = authRepo;
  }

  async execute(refreshToken: string, cognitoId: string) {
    const accessToken = await this.authRepo.refreshAccessToken(
      refreshToken,
      cognitoId
    );
    if (accessToken) {
      return accessToken;
    } else {
      throw new Error("Could not refresh session with AWS Cognito");
    }
  }
}
