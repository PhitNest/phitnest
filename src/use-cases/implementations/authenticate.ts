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

  execute(accessToken: string) {
    return this.authRepo.getUserId(accessToken);
  }
}
