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

  async execute(cognitoId: string) {
    const gym = await this.gymRepo.getByUser(cognitoId);
    if (gym) {
      return gym;
    } else {
      throw new Error(`Could not get gym for user with id: ${cognitoId}`);
    }
  }
}
