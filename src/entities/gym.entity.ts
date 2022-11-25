import mongoose from "mongoose";
import { IAddressEntity } from "./address.entity";
import { ILocationEntity } from "./location.entity";

export interface IGymEntity extends mongoose.Document {
  name: Readonly<string>;
  address: Readonly<IAddressEntity>;
  location: Readonly<ILocationEntity>;
}
