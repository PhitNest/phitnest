import { inject, injectable } from "inversify";
import { Repositories } from "../../common/dependency-injection";
import { IAuthRepository } from "../../repositories/interfaces";
import { IForgotPasswordUseCase } from "../interfaces";

@injectable()
export class ForgotPasswordUseCase implements IForgotPasswordUseCase {
  authRepo: IAuthRepository;

  constructor(@inject(Repositories.auth) authRepo: IAuthRepository) {
    this.authRepo = authRepo;
  }

  async execute(email: string) {
    if (!(await this.authRepo.forgotPassword(email))) {
      throw new Error("Could not send forgot password email");
    }
  }
}
