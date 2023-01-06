import { inject, injectable } from "inversify";
import { Repositories } from "../../common/dependency-injection";
import { IProfilePictureRepository } from "../../repositories/interfaces";
import { IGetProfilePictureUseCase } from "../interfaces";

@injectable()
export class GetProfilePictureUseCase implements IGetProfilePictureUseCase {
  profilePictureRepo: IProfilePictureRepository;

  constructor(
    @inject(Repositories.profilePicture)
    profilePictureRepo: IProfilePictureRepository
  ) {
    this.profilePictureRepo = profilePictureRepo;
  }

  execute(cognitoId: string) {
    return this.profilePictureRepo.getPresignedGetURL(cognitoId);
  }
}
