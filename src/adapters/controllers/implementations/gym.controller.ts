import { inject, injectable } from "inversify";
import { z } from "zod";
import { UseCases } from "../../../common/dependency-injection";
import { LocationEntity } from "../../../entities";
import {
  ICreateGymUseCase,
  IGetGymUseCase,
  IGetNearestGymsUseCase,
} from "../../../use-cases/interfaces";
import { AuthenticatedLocals, IRequest, IResponse } from "../../types";
import { IGymController } from "../interfaces";

const addressValidator = z.object({
  street: z.string(),
  city: z.string(),
  state: z.string().length(2),
  zipCode: z.string().length(5),
});

@injectable()
export class GymController implements IGymController {
  getGymUseCase: IGetGymUseCase;
  getNearestGymsUseCase: IGetNearestGymsUseCase;
  createGymUseCase: ICreateGymUseCase;

  constructor(
    @inject(UseCases.getGym) getGymUseCase: IGetGymUseCase,
    @inject(UseCases.getNearestGyms)
    getNearestGymsUseCase: IGetNearestGymsUseCase,
    @inject(UseCases.createGym) createGymUseCase: ICreateGymUseCase
  ) {
    this.getGymUseCase = getGymUseCase;
    this.getNearestGymsUseCase = getNearestGymsUseCase;
    this.createGymUseCase = createGymUseCase;
  }

  async create(req: IRequest, res: IResponse) {
    try {
      const { name, address } = z
        .object({ name: z.string(), address: addressValidator })
        .parse(req.content());
      const gym = await this.createGymUseCase.execute(name, address);
      return res.status(201).json(gym);
    } catch (err) {
      if (err instanceof z.ZodError) {
        return res.status(400).json(err.issues);
      } else if (err instanceof Error) {
        return res.status(500).json(err.message);
      } else {
        return res.status(500).send(err);
      }
    }
  }

  async getNearest(req: IRequest, res: IResponse) {
    try {
      const { longitude, latitude, distance, amount } = z
        .object({
          longitude: z.number().gte(-180).lte(180),
          latitude: z.number().gte(-90).lte(90),
          distance: z.number().positive(),
          amount: z.number().int().positive().optional(),
        })
        .parse(req.content());
      const gyms = await this.getNearestGymsUseCase.execute(
        new LocationEntity(longitude, latitude),
        distance,
        amount
      );
      return res.status(200).json(gyms);
    } catch (err) {
      if (err instanceof z.ZodError) {
        return res.status(400).json(err.issues);
      } else if (err instanceof Error) {
        return res.status(500).json(err.message);
      } else {
        return res.status(500).send(err);
      }
    }
  }

  async get(req: IRequest, res: IResponse<AuthenticatedLocals>) {
    try {
      const gym = await this.getGymUseCase.execute(res.locals.cognitoId);
      return res.status(200).json(gym);
    } catch (err) {
      if (err instanceof Error) {
        return res.status(500).json(err.message);
      } else {
        return res.status(500).send(err);
      }
    }
  }
}
