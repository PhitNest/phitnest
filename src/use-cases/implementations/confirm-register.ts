import { inject, injectable } from "inversify";
import { Repositories } from "../../common/dependency-injection";
import {
  IAuthRepository,
  IProfilePictureRepository,
  IUserRepository,
} from "../../repositories/interfaces";
import { IConfirmRegisterUseCase } from "../interfaces";

@injectable()
export class ConfirmRegisterUseCase implements IConfirmRegisterUseCase {
  authRepo: IAuthRepository;
  profilePictureRepo: IProfilePictureRepository;
  userRepo: IUserRepository;

  constructor(
    @inject(Repositories.auth) authRepo: IAuthRepository,
    @inject(Repositories.profilePicture)
    profilePictureRepo: IProfilePictureRepository,
    @inject(Repositories.user) userRepo: IUserRepository
  ) {
    this.authRepo = authRepo;
    this.profilePictureRepo = profilePictureRepo;
    this.userRepo = userRepo;
  }

  async execute(email: string, code: string) {
    const user = await this.userRepo.getByEmail(email);
    if (user) {
      if (await this.profilePictureRepo.hasProfilePicture(user.cognitoId)) {
        await this.userRepo.confirmUser(user.cognitoId);
        await this.authRepo.confirmRegister(email, code);
      } else {
        throw new Error(
          `User with email: ${email} does not have a profile picture`
        );
      }
    } else {
      throw new Error(`Could not find user with email: ${email}`);
    }
  }
}
