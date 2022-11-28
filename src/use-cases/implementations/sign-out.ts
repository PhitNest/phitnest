import { inject, injectable } from "inversify";
import { Repositories } from "../../common/dependency-injection";
import { IAuthRepository } from "../../repositories/interfaces";
import { ISignOutUseCase } from "../interfaces";

@injectable()
export class SignOutUseCase implements ISignOutUseCase {
  authRepo: IAuthRepository;

  constructor(@inject(Repositories.auth) authRepo: IAuthRepository) {
    this.authRepo = authRepo;
  }

  async execute(cognitoId: string, allDevices: boolean) {
    if (!(await this.authRepo.signOut(cognitoId, allDevices))) {
      throw new Error("Failed to sign out");
    }
  }
}
