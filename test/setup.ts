import dotenv from "dotenv";
dotenv.config();
import { startMockServer } from "./helpers/mock-mongo";

export default async function () {
  await startMockServer();
}
