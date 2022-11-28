import { Controller } from "../../types";

export interface IAuthController {
  login: Controller;
  register: Controller;
  confirmRegister: Controller;
  refreshSession: Controller;
}
