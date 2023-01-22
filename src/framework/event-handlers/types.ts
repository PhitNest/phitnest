import { Failure } from "../../common/types";
import { IConnection } from "../adapters/interfaces";

export type EventHandler<DataType, ResType> = (
  data: DataType,
  connection: IConnection
) => Promise<ResType | Failure>;
