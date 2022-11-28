import { AuthenticatedLocals, Controller } from "../../types";

export interface IGymController {
  // TODO: SECURE THIS WITH ADMIN AUTH FOR PROD
  create: Controller;

  get: Controller<AuthenticatedLocals>;
  getNearest: Controller;
}
