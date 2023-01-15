import { IRequest, IResponse } from "../../../common/types";
import { z } from "zod";
import { Controller, HttpMethod } from "../types";
import { IGymEntity, LocationEntity } from "../../../domain/entities";
import { gymRepo } from "../../../domain/repositories";

const nearestGyms = z.object({
  longitude: z.number(),
  latitude: z.number(),
  meters: z.number().positive(),
  amount: z.number().int().optional(),
});

type NearestGymsRequest = z.infer<typeof nearestGyms>;

export class NearestGymsController
  implements Controller<NearestGymsRequest, IGymEntity[]>
{
  method = HttpMethod.GET;

  validate(body: any) {
    return nearestGyms.parse({
      longitude: parseFloat(body.longitude),
      latitude: parseFloat(body.latitude),
      meters: parseFloat(body.meters),
      ...(body.amount ? { amount: parseInt(body.amount) } : {}),
    });
  }

  execute(req: IRequest<NearestGymsRequest>, res: IResponse<IGymEntity[]>) {
    return gymRepo.getNearest(
      new LocationEntity(req.body.longitude, req.body.latitude),
      req.body.meters,
      req.body.amount
    );
  }
}
