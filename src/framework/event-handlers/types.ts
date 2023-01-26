import { z } from "zod";
import { Failure } from "../../common/types";
import { IConnection } from "../adapters/interfaces";

export interface EventHandler<ResType> {
  validator?: z.ZodObject<any>;

  event: string;

  execute(data: any, connection: IConnection): Promise<ResType | Failure>;
}
