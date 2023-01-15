import { IGymEntity, LocationEntity } from "../entities";
import dataSources from "../../data/data-sources/injection";

class GymRepository {
  create(gym: Omit<IGymEntity, "_id">) {
    return dataSources().gymDatabase.create(gym);
  }

  getNearest(location: LocationEntity, meters: number, amount?: number) {
    return dataSources().gymDatabase.getNearest(location, meters, amount);
  }

  get(gymId: string) {
    return dataSources().gymDatabase.get(gymId);
  }

  deleteAll() {
    return dataSources().gymDatabase.deleteAll();
  }
}

export const gymRepo = new GymRepository();
