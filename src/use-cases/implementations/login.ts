import { inject, injectable } from "inversify";
import { Repositories } from "../../common/dependency-injection";
import { IAuthRepository } from "../../repositories/interfaces";
import { ILoginUseCase } from "../interfaces";

@injectable()
export class LoginUseCase implements ILoginUseCase {
  authRepo: IAuthRepository;

  constructor(@inject(Repositories.auth) authRepo: IAuthRepository) {
    this.authRepo = authRepo;
  }

  async execute(email: string, password: string) {
    const accessToken = await this.authRepo.login(email, password);
    if (accessToken) {
      return accessToken;
    } else {
      throw new Error("Could not login user with AWS Cognito");
    }
  }
}
