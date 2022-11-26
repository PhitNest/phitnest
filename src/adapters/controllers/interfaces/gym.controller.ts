import { AuthenticatedLocals, Controller } from "../../types";

export interface IGymController {
  // TODO: DELETE THIS FOR PROD
  create: Controller<AuthenticatedLocals>;

  get: Controller<AuthenticatedLocals>;
  getNearest: Controller;
}
