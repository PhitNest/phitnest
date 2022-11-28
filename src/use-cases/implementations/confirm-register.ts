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

  execute(email: string, code: string) {
    return this.authRepo.confirmRegister(email, code);
  }
}
