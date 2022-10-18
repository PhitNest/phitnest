import mongoose from "mongoose";

export interface IAddressModel extends mongoose.Document {
  street: string;
  city: string;
  state: string;
  zipCode: string;
}
