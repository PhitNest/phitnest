import { inject, injectable } from "inversify";
import { Repositories } from "../../common/dependency-injection";
import { IProfilePictureRepository } from "../../repositories/interfaces";
import { IGetUploadProfilePictureURLUseCase } from "../interfaces";

@injectable()
export class GetUploadProfilePictureURLUseCase
  implements IGetUploadProfilePictureURLUseCase
{
  profilePictureRepo: IProfilePictureRepository;

  constructor(
    @inject(Repositories.profilePicture)
    profilePictureRepo: IProfilePictureRepository
  ) {
    this.profilePictureRepo = profilePictureRepo;
  }

  async execute(cognitoId: string): Promise<string> {
    return this.profilePictureRepo.getPresignedUploadURL(cognitoId);
  }
}
