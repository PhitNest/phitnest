import { Controller } from "../../controllers/types";
import { Middleware } from "../../middleware/types";

export interface IServer {
  listen(port: number): Promise<void>;

  close(): Promise<void>;

  bind<BodyType, ResType, LocalsType>(options: {
    route: string;
    controller: Controller<BodyType, ResType, LocalsType>;
    middleware?: Middleware<BodyType, ResType, LocalsType>[];
  }): void;
}
