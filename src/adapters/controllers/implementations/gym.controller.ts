import { inject, injectable } from "inversify";
import { z } from "zod";
import { UseCases } from "../../../common/dependency-injection";
import {
  IGetGymUseCase,
  IGetNearestGymsUseCase,
} from "../../../use-cases/interfaces";
import { AuthenticatedLocals, IRequest, IResponse } from "../../types";
import { IGymController } from "../interfaces";

@injectable()
export class GymController implements IGymController {
  getGymUseCase: IGetGymUseCase;
  getNearestGymsUseCase: IGetNearestGymsUseCase;

  constructor(
    @inject(UseCases.getGym) getGymUseCase: IGetGymUseCase,
    @inject(UseCases.getNearestGyms)
    getNearestGymsUseCase: IGetNearestGymsUseCase
  ) {
    this.getGymUseCase = getGymUseCase;
    this.getNearestGymsUseCase = getNearestGymsUseCase;
  }

  async getNearest(req: IRequest, res: IResponse) {
    try {
      const { longitude, latitude, distance, amount } = z
        .object({
          longitude: z.number().gte(-180).lte(180),
          latitude: z.number().gte(-90).lte(90),
          distance: z.number().positive(),
          amount: z.number().int().nonnegative(),
        })
        .parse(req.content());
      const gyms = await this.getNearestGymsUseCase.execute(
        { longitude: longitude, latitude: latitude },
        distance,
        amount
      );
      if (gyms) {
        return res.status(200).json(gyms);
      } else {
        return res.status(500).json({ message: "Could not find gyms" });
      }
    } catch (err) {
      return res
        .status(500)
        .json({ message: "An internal service error occurred" });
    }
  }

  async get(req: IRequest, res: IResponse<AuthenticatedLocals>) {
    try {
      const gym = await this.getGymUseCase.execute(res.locals.userId);
      if (gym) {
        return res.status(200).json(gym);
      } else {
        return res.status(500).json({ message: "Could not find a gym" });
      }
    } catch (err) {
      return res
        .status(500)
        .json({ message: "An internal service error occurred" });
    }
  }
}
