import mongoose from "mongoose";
import { AddressModel } from "./address.model";
import { LocationModel } from "./location.model";

export interface IGymModel extends mongoose.Document {
  name: string;
  address: AddressModel;
  location: LocationModel;
}

const schema = new mongoose.Schema(
  {
    name: { type: String, required: true, trim: true },
    address: {
      street: { type: String, required: true, trim: true },
      city: { type: String, required: true, trim: true },
      state: { type: String, required: true, trim: true },
      zipCode: { type: String, required: true, trim: true },
    },
    location: {
      type: { type: String },
      coordinates: [Number],
    },
  },
  {
    collection: "gyms",
  }
);

schema.index({ location: "2dsphere" });

export const Gym = mongoose.model<IGymModel>("Gym", schema);
