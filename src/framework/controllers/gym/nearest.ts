import { IRequest, IResponse } from "../../../common/types";
import { z } from "zod";
import { Controller, HttpMethod } from "../types";
import { IGymEntity, LocationEntity } from "../../../domain/entities";
import { gymRepo } from "../../../domain/repositories";

export class NearestGymsController implements Controller<IGymEntity[]> {
  method = HttpMethod.GET;

  route = "/gym/nearest";

  validator = z.object({
    longitude: z.coerce.number(),
    latitude: z.coerce.number(),
    meters: z.coerce.number().positive(),
    amount: z.coerce.number().int().optional(),
  });

  execute(
    req: IRequest<z.infer<typeof this.validator>>,
    res: IResponse<IGymEntity[]>
  ) {
    return gymRepo.getNearest(
      new LocationEntity(req.body.longitude, req.body.latitude),
      req.body.meters,
      req.body.amount
    );
  }
}
