import { inject, injectable } from "inversify";
import { z } from "zod";
import { UseCases } from "../../../common/dependency-injection";
import {
  statusCreated,
  statusInternalServerError,
  statusOK,
} from "../../../constants/http_codes";
import { IGymEntity, LocationEntity } from "../../../entities";
import {
  ICreateGymUseCase,
  IGetGymUseCase,
  IGetNearestGymsUseCase,
} from "../../../use-cases/interfaces";
import { IAuthenticatedResponse, IRequest, IResponse } from "../../types";
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

  async create(req: IRequest, res: IResponse<IGymEntity>) {
    try {
      const { name, address } = z
        .object({ name: z.string(), address: addressValidator })
        .parse(req.content());
      const gym = await this.createGymUseCase.execute(name, address);
      return res.status(statusCreated).json(gym);
    } catch (err) {
      return res.status(statusInternalServerError).send(err);
    }
  }

  async getNearest(req: IRequest, res: IResponse<IGymEntity[]>) {
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
      return res.status(statusOK).json(gyms);
    } catch (err) {
      return res.status(statusInternalServerError).send(err);
    }
  }

  async get(req: IRequest, res: IAuthenticatedResponse<IGymEntity>) {
    try {
      const gym = await this.getGymUseCase.execute(res.locals.cognitoId);
      return res.status(statusOK).json(gym);
    } catch (err) {
      return res.status(statusInternalServerError).send(err);
    }
  }
}
