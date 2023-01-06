import { z } from "zod";
import {
  IProfilePictureExploreUserEntity,
  IProfilePictureUserEntity,
} from "../../../entities";
import { AuthenticatedController, Controller } from "../../types";

export interface IUserController {
  get: AuthenticatedController<IProfilePictureUserEntity>;

  explore: AuthenticatedController<IProfilePictureExploreUserEntity[]>;

  tutorialExplore: Controller<IProfilePictureExploreUserEntity[]>;

  getProfilePictureUploadUrl: AuthenticatedController<{
    uploadProfilePicture: string;
  }>;
}
