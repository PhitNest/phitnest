import { IProfilePictureExploreUserEntity } from "../../entities";
import { IUseCase } from "../types";

export interface ITutorialExploreUseCase extends IUseCase {
  execute: (
    gymId: string,
    offset?: number,
    limit?: number
  ) => Promise<IProfilePictureExploreUserEntity[]>;
}
