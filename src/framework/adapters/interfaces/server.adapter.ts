import { Controller } from "../../controllers/types";
import http from "http";

export interface IServer {
  listen(port: number): Promise<http.Server>;

  bind<BodyType, ResType, LocalsType>(options: {
    route: string;
    controller: Controller<BodyType, ResType, LocalsType>;
  }): void;
}
