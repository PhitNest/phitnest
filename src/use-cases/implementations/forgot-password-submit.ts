import { inject, injectable } from "inversify";
import { Repositories } from "../../common/dependency-injection";
import { IAuthRepository } from "../../repositories/interfaces";
import { IForgotPasswordSubmitUseCase } from "../interfaces";

@injectable()
export class ForgotPasswordSubmitUseCase
  implements IForgotPasswordSubmitUseCase
{
  authRepo: IAuthRepository;

  constructor(@inject(Repositories.auth) authRepo: IAuthRepository) {
    this.authRepo = authRepo;
  }

  async execute(email: string, code: string, newPassword: string) {
    if (!(await this.authRepo.forgotPasswordSubmit(email, code, newPassword))) {
      throw new Error("Could not submit forgot password");
    }
  }
}
