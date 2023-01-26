import { Controller } from "../../controllers/types";
import http from "http";

export interface IServer {
  listen(port: number): Promise<http.Server>;

  bind(controller: Controller<any>): void;
}
