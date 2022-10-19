import { IGymModel, Gym } from "../models/gym.model";
import { IAddressModel } from "../models/address.model";
import { ILocationModel } from "../models/location.model";

class GymQueries {
  createGym(
    name: string,
    address: IAddressModel,
    location: ILocationModel
  ): Promise<IGymModel> {
    return Gym.create({
      name: name,
      address: address,
      location: location,
    });
  }

  nearestGyms(
    lon: number,
    lat: number,
    distance: number,
    amount: number
  ): Promise<IGymModel[]> {
    const query = Gym.find({
      location: {
        $near: {
          $maxDistance: distance,
          $geometry: { type: "Point", coordinates: [lon, lat] },
        },
      },
    });
    if (amount > 0) {
      query.limit(amount);
    }
    return query.exec();
  }

  async nearestGym(
    lon: number,
    lat: number,
    distance: number
  ): Promise<IGymModel> {
    return (await this.nearestGyms(lon, lat, distance, 1))[0];
  }
}

export default new GymQueries();
