import { inject, injectable } from "inversify";
import { Repositories } from "../../common/dependency-injection";
import {
  IProfilePictureRepository,
  IUserRepository,
} from "../../repositories/interfaces";
import { IExploreUseCase } from "../interfaces/explore";

@injectable()
export class ExploreUseCase implements IExploreUseCase {
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

  async execute(cognitoId: string, offset?: number, limit?: number) {
    return Promise.all(
      (await this.userRepo.exploreUsers(cognitoId, offset, limit)).map(
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
