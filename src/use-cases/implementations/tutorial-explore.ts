import { inject, injectable } from "inversify";
import { Repositories } from "../../common/dependency-injection";
import {
  IProfilePictureRepository,
  IUserRepository,
} from "../../repositories/interfaces";
import { ITutorialExploreUseCase } from "../interfaces";

@injectable()
export class TutorialExploreUseCase implements ITutorialExploreUseCase {
  userRepo: IUserRepository;
  profilePictureRepo: IProfilePictureRepository;

  constructor(
    @inject(Repositories.user) userRepo: IUserRepository,
    @inject(Repositories.profilePicture)
    profilePictureRepo: IProfilePictureRepository
  ) {
    this.userRepo = userRepo;
    this.profilePictureRepo = profilePictureRepo;
  }

  async execute(gymId: string, offset?: number, limit?: number) {
    return Promise.all(
      (await this.userRepo.tutorialExploreUsers(gymId, offset, limit)).map(
        async (user) => ({
          _id: user._id,
          cognitoId: user.cognitoId,
          firstName: user.firstName,
          lastName: user.lastName,
          profilePicture: await this.profilePictureRepo.getPresignedGetURL(
            user.cognitoId
          ),
        })
      )
    );
  }
}
