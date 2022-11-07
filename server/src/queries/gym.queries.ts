import { IGymModel, Gym } from "../models/gym.model";
import { User } from "../models/user.model";
import { AddressModel } from "../models/address.model";
import { LocationModel } from "../models/location.model";

export class GymQueries {
  static createGym(
    name: string,
    address: AddressModel,
    location: LocationModel
  ): Promise<IGymModel> {
    return Gym.create({
      name: name,
      address: address,
      location: location,
    });
  }

  static async myGym(cognitoId: string): Promise<IGymModel> {
    return Gym.findById((await User.findOne({ cognitoId: cognitoId })).gymId);
  }

  static nearestGyms(
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

  static async nearestGym(
    lon: number,
    lat: number,
    distance: number
  ): Promise<IGymModel> {
    return (await GymQueries.nearestGyms(lon, lat, distance, 1))[0];
  }
}
