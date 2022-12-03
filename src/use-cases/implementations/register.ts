import { inject, injectable } from "inversify";
import { Repositories } from "../../common/dependency-injection";
import {
  IAuthRepository,
  IGymRepository,
  IUserRepository,
} from "../../repositories/interfaces";
import { IRegisterUseCase } from "../interfaces";

@injectable()
export class RegisterUseCase implements IRegisterUseCase {
  authRepo: IAuthRepository;
  userRepo: IUserRepository;
  gymRepo: IGymRepository;

  constructor(
    @inject(Repositories.auth) authRepo: IAuthRepository,
    @inject(Repositories.user) userRepo: IUserRepository,
    @inject(Repositories.gym) gymRepo: IGymRepository
  ) {
    this.authRepo = authRepo;
    this.userRepo = userRepo;
    this.gymRepo = gymRepo;
  }

  async execute(
    email: string,
    password: string,
    gymId: string,
    firstName: string,
    lastName: string
  ) {
    const gym = await this.gymRepo.get(gymId);
    if (gym) {
      const cognitoId = await this.authRepo.registerUser(email, password);
      await this.userRepo.create({
        cognitoId: cognitoId,
        email: email,
        gymId: gymId,
        firstName: firstName,
        lastName: lastName,
      });
    } else {
      throw new Error("Gym not found");
    }
  }
}
