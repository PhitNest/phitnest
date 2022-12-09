import { injectable } from "inversify";
import { IRoute } from "./types";

@injectable()
export class DirectMessageRouter {
  routes: IRoute[];

  constructor() {
    this.routes = [];
  }
}
