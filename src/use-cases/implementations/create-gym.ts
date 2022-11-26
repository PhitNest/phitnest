import { inject, injectable } from "inversify";
import { Repositories } from "../../common/dependency-injection";
import { IAddressEntity } from "../../entities";
import {
  IGymRepository,
  ILocationRepository,
} from "../../repositories/interfaces";
import { ICreateGymUseCase } from "../interfaces";

@injectable()
export class CreateGymUseCase implements ICreateGymUseCase {
  gymRepo: IGymRepository;
  locationRepo: ILocationRepository;

  constructor(
    @inject(Repositories.gym) gymRepo: IGymRepository,
    @inject(Repositories.location) locationRepo: ILocationRepository
  ) {
    this.gymRepo = gymRepo;
    this.locationRepo = locationRepo;
  }

  async execute(name: string, address: IAddressEntity) {
    const location = await this.locationRepo.get(address);
    if (location) {
      return this.gymRepo.create(name, address, location);
    } else {
      throw new Error("Address could not be located");
    }
  }
}
