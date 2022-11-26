import { IAddressEntity, IGymEntity } from "../../entities";
import { IUseCase } from "../types";

export interface ICreateGymUseCase extends IUseCase {
  execute: (name: string, address: IAddressEntity) => Promise<IGymEntity>;
}
