import { GetNearestGymsUseCase } from "../../../domain/use-cases";
import { Controller } from "../controller";
import { z } from "zod";

const validator = z.object({
  longitude: z.number().gte(-180).lte(180),
  latitude: z.number().gte(-90).lte(90),
  distance: z.number().positive(),
  amount: z.number().int().nonnegative(),
});

export function buildGetGymController(
  getNearestGyms: GetNearestGymsUseCase
): Controller {
  return async (req, res) => {
    try {
      const { longitude, latitude, distance, amount } = validator.parse(
        req.content()
      );
      const gyms = await getNearestGyms(
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
  };
}
