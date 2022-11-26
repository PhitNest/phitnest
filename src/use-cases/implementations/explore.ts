import { inject, injectable } from "inversify";
import { Repositories } from "../../common/dependency-injection";
import { IUserRepository } from "../../repositories/interfaces";
import { IExploreUseCase } from "../interfaces/explore";

@injectable()
export class ExploreUseCase implements IExploreUseCase {
  userRepo: IUserRepository;

  constructor(@inject(Repositories.user) userRepo: IUserRepository) {
    this.userRepo = userRepo;
  }

  async execute(cognitoId: string, offset?: number, limit?: number) {
    return this.userRepo.exploreUsers(cognitoId, offset, limit);
  }
}
