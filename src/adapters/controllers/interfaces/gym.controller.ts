import { Controller } from "../../types";

export interface IGymController {
  get: Controller;
  getNearest: Controller;
}
