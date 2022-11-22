import { IGymEntity } from "../../../domain/entities";

export interface IUserRepository {
  getGym(userId: string): Promise<IGymEntity>;
}
