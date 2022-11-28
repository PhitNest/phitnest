import { inject, injectable } from "inversify";
import { Repositories } from "../../common/dependency-injection";
import { IAuthRepository } from "../../repositories/interfaces";
import { IConfirmRegisterUseCase } from "../interfaces";

@injectable()
export class ConfirmRegisterUseCase implements IConfirmRegisterUseCase {
  authRepo: IAuthRepository;

  constructor(@inject(Repositories.auth) authRepo: IAuthRepository) {
    this.authRepo = authRepo;
  }

  async execute(email: string, code: string) {
    if (!(await this.authRepo.confirmRegister(email, code))) {
      throw new Error("Could not confirm registration with AWS Cognito");
    }
  }
}
