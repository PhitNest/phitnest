import { inject, injectable } from "inversify";
import { Repositories } from "../../common/dependency-injection";
import { IAuthenticateUseCase } from "../interfaces";
import { IAuthRepository } from "../../repositories/interfaces";

@injectable()
export class AuthenticateUseCase implements IAuthenticateUseCase {
  authRepo: IAuthRepository;

  constructor(@inject(Repositories.auth) authRepo: IAuthRepository) {
    this.authRepo = authRepo;
  }

  async execute(accessToken: string) {
    const userId = await this.authRepo.getCognitoId(accessToken);
    if (userId) {
      return userId;
    } else {
      throw new Error("Could not authenticate user with AWS Cognito");
    }
  }
}
