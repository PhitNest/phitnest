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
    const user = await this.userRepo.get(cognitoId);
    if (user) {
      return user;
    } else {
      throw new Error(`Could not get user with id: ${cognitoId}`);
    }
  }
}
