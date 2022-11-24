import { inject, injectable } from "inversify";
import { Repositories } from "../../common/dependency-injection";
import { IGymRepository } from "../../repositories/interfaces";
import { IGetGymUseCase } from "../interfaces";

@injectable()
export class GetGymUseCase implements IGetGymUseCase {
  gymRepo: IGymRepository;

  constructor(@inject(Repositories.gym) gymRepo: IGymRepository) {
    this.gymRepo = gymRepo;
  }

  execute(userId: string) {
    return this.gymRepo.get(userId);
  }
}
