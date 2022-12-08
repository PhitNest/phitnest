import { AuthenticatedLocals, Controller } from "../../types";

export interface IUserController {
  get: Controller<AuthenticatedLocals>;
  explore: Controller<AuthenticatedLocals>;
  tutorialExplore: Controller;
}
