import { inject, injectable } from "inversify";
import { Repositories } from "../../common/dependency-injection";
import { IUserRepository } from "../../repositories/interfaces";
import { IGetUserByEmailUseCase } from "../interfaces";

@injectable()
export class GetUserByEmailUseCase implements IGetUserByEmailUseCase {
  userRepo: IUserRepository;

  constructor(@inject(Repositories.user) userRepo: IUserRepository) {
    this.userRepo = userRepo;
  }

  async execute(email: string) {
    const user = await this.userRepo.getByEmail(email);
    if (user) {
      return user;
    } else {
      throw new Error("User not found");
    }
  }
}
