import mongoose from "mongoose";

export interface ILocationModel extends mongoose.Document {
  type: string;
  coordinates: number[];
}
