import { inject, injectable } from "inversify";
import { Repositories } from "../../common/dependency-injection";
import { IUserRepository } from "../../repositories/interfaces";
import { IGetUserUseCase } from "../interfaces";

@injectable()
export class GetUserUseCase implements IGetUserUseCase {
  userRepo: IUserRepository;

  constructor(@inject(Repositories.user) userRepo: IUserRepository) {
    this.userRepo = userRepo;
  }

  async execute(cognitoId: string) {
    return this.userRepo.get(cognitoId);
  }
}
