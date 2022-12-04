import { inject, injectable } from "inversify";
import { Repositories } from "../../common/dependency-injection";
import { IAuthRepository } from "../../repositories/interfaces";
import { IRefreshSessionUseCase } from "../interfaces";

@injectable()
export class RefreshSessionUseCase implements IRefreshSessionUseCase {
  authRepo: IAuthRepository;

  constructor(@inject(Repositories.auth) authRepo: IAuthRepository) {
    this.authRepo = authRepo;
  }

  async execute(refreshToken: string, email: string) {
    return this.authRepo.refreshSession(refreshToken, email);
  }
}
