import "mocha";
import { setup } from "./constants";
import mongoose from "mongoose";
import { beforeEach } from "mocha";

export function clear() {
  shouldClear = true;
}

let shouldClear = true;

before(function (done) {
  this.timeout(15000);
  const db = mongoose.connection;
  db.once("open", async () => {
    done();
  });
});

// clear database before each test
beforeEach(async () => {
  if (shouldClear) {
    const db = mongoose.connection;
    await db.dropDatabase();
    await setup();
    shouldClear = false;
  }
});
