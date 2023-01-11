import { HttpMethod } from "../../common/types";
import { Controller } from "../../controllers/types";
import { Middleware } from "../../middleware/types";
import { Validator } from "../../validators/types";

export interface IServer {
  listen(port: number): Promise<void>;

  close(): Promise<void>;

  bind<BodyType, ResType, LocalsType>(options: {
    method: HttpMethod;
    route: string;
    validator: Validator<BodyType>;
    middleware: Middleware<BodyType, ResType, LocalsType>[];
    controller: Controller<BodyType, ResType, LocalsType>;
  }): void;
}
