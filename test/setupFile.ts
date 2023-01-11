import { start, stop } from "../src/app";
import { dropDatabase } from "./helpers/mock-mongo";

beforeAll(start);

afterAll(async () => {
  await dropDatabase();
  await stop();
});
