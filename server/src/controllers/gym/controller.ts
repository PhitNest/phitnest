import { Request, Response } from "express";
import { GymQueries } from "../../queries/gym.queries";
import { IGymModel } from "../../models/gym.model";

function gymResponse(gym: IGymModel) {
  return {
    id: gym._id,
    name: gym.name,
    address: gym.address,
    location: {
      longitude: gym.location.coordinates[0],
      latitude: gym.location.coordinates[1],
    },
  };
}

class GymController {
  async createGym(req: Request, res: Response) {
    const gym = await GymQueries.createGym(
      req.body.name,
      req.body.address,
      res.locals.location
    );
    return res.status(200).json(gymResponse(gym));
  }

  async nearestGyms(req: Request, res: Response) {
    const gyms = await GymQueries.nearestGyms(
      parseFloat(req.query.longitude.toString()),
      parseFloat(req.query.latitude.toString()),
      parseFloat(req.query.distance.toString()) * 1600,
      req.query.amount ? parseInt(req.query.amount.toString()) : null
    );
    return res.status(200).json(gyms.map((gym) => gymResponse(gym)));
  }

  async nearestGym(req: Request, res: Response) {
    const gym = await GymQueries.nearestGym(
      parseFloat(req.query.longitude.toString()),
      parseFloat(req.query.latitude.toString()),
      parseFloat(req.query.distance.toString()) * 1600
    );
    return gym
      ? res.status(200).json(gymResponse(gym))
      : res.status(204).send();
  }
}

export default new GymController();
