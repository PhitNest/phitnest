import mongoose from "mongoose";
import { IDatabase } from "../interfaces";

export class MongooseDatabase implements IDatabase {
  async connect(host: string) {
    await mongoose.connect(host);
    console.log("Connected to MongoDB");
  }

  async disconnect() {
    await mongoose.disconnect();
    console.log("Disconnected from MongoDB");
  }
}
