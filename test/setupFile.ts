import mongoose from "mongoose";
import { start, stop } from "../src/app";

beforeAll(start);

afterAll(async () => {
  await mongoose.connection.db.dropDatabase();
  await stop();
});
