import { inject, injectable } from "inversify";
import { Repositories } from "../../common/dependency-injection";
import { IAuthRepository } from "../../repositories/interfaces";
import { IResendConfirmationUseCase } from "../interfaces";

@injectable()
export class ResendConfirmationUseCase implements IResendConfirmationUseCase {
  authRepo: IAuthRepository;

  constructor(@inject(Repositories.auth) authRepo: IAuthRepository) {
    this.authRepo = authRepo;
  }

  async execute(email: string) {
    if (!(await this.authRepo.resendConfirmationCode(email))) {
      throw new Error("Could not resend confirmation code");
    }
  }
}
