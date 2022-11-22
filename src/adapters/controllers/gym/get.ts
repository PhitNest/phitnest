import { GetGymUseCase } from "../../../domain/use-cases";
import { Controller } from "../controller";
import { AuthenticatedLocals } from "../locals";

export function buildGetGymController(
  getGym: GetGymUseCase
): Controller<AuthenticatedLocals> {
  return async (req, res) => {
    try {
      const gym = await getGym(res.locals.userId);
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
  };
}
