import { IGymEntity } from "../../../entities";
import { AuthenticatedController, Controller } from "../../types";

export interface IGymController {
  // TODO: SECURE THIS WITH ADMIN AUTH FOR PROD
  create: Controller<IGymEntity>;

  get: AuthenticatedController<IGymEntity>;
  getNearest: Controller<IGymEntity[]>;
}
