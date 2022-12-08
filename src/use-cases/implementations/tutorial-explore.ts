import { inject, injectable } from "inversify";
import { Repositories } from "../../common/dependency-injection";
import { IUserRepository } from "../../repositories/interfaces";
import { ITutorialExploreUseCase } from "../interfaces";

@injectable()
export class TutorialExploreUseCase implements ITutorialExploreUseCase {
  userRepo: IUserRepository;

  constructor(@inject(Repositories.user) userRepo: IUserRepository) {
    this.userRepo = userRepo;
  }

  execute(gymId: string, offset?: number, limit?: number) {
    return this.userRepo.tutorialExploreUsers(gymId, offset, limit);
  }
}
