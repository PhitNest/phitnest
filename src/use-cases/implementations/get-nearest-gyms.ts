import { inject, injectable } from "inversify";
import { Repositories } from "../../common/dependency-injection";
import { ILocationEntity } from "../../entities";
import { IGymRepository } from "../../repositories/interfaces";
import { IGetNearestGymsUseCase } from "../interfaces";

@injectable()
export class GetNearestGymsUseCase implements IGetNearestGymsUseCase {
  gymRepo: IGymRepository;

  constructor(@inject(Repositories.gym) gymRepo: IGymRepository) {
    this.gymRepo = gymRepo;
  }

  execute(location: ILocationEntity, distance: number, amount: number) {
    return this.gymRepo.getNearest(location, distance, amount);
  }
}
