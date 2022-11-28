import { inject, injectable } from "inversify";
import { Repositories } from "../../common/dependency-injection";
import {
  IAuthRepository,
  IUserRepository,
} from "../../repositories/interfaces";
import { IRegisterUseCase } from "../interfaces";

@injectable()
export class RegisterUseCase implements IRegisterUseCase {
  authRepo: IAuthRepository;
  userRepo: IUserRepository;

  constructor(
    @inject(Repositories.auth) authRepo: IAuthRepository,
    @inject(Repositories.user) userRepo: IUserRepository
  ) {
    this.authRepo = authRepo;
    this.userRepo = userRepo;
  }

  async execute(
    email: string,
    password: string,
    gymId: string,
    firstName: string,
    lastName: string
  ) {
    const cognitoId = await this.authRepo.registerUser(email, password);
    if (cognitoId) {
      await this.userRepo.create({
        cognitoId: cognitoId,
        email: email,
        gymId: gymId,
        firstName: firstName,
        lastName: lastName,
      });
    } else {
      throw new Error("Could not register user with AWS Cognito");
    }
  }
}
