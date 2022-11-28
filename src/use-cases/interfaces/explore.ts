import { IPublicUserEntity } from "../../entities";
import { IUseCase } from "../types";

export interface IExploreUseCase extends IUseCase {
  execute: (
    cognitoId: string,
    offset?: number,
    limit?: number
  ) => Promise<Omit<IPublicUserEntity, "gymId">[]>;
}
