import { IGymEntity } from "../../entities";
import { IUseCase } from "../types";

export interface IGetGymUseCase extends IUseCase {
  execute(cognitoId: string): Promise<IGymEntity>;
}
