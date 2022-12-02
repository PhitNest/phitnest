import { IEventHandler } from "../adapters/types";

export interface IEvent {
  name: string;
  handler: IEventHandler;
}
