import { stopMockServer } from "./helpers/mock-mongo";

export default async function () {
  await stopMockServer();
}
