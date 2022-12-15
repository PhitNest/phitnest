import { injectable } from "inversify";
import { IRoute } from "./types";

@injectable()
export class MessageRouter {
  routes: IRoute[];

  constructor() {
    this.routes = [];
  }
}
