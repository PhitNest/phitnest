import "mocha";
import { setup } from "./constants";
import mongoose from "mongoose";

// clear database after connected
before(function (done) {
  this.timeout(15000);
  const db = mongoose.connection;
  db.once("open", async () => {
    await db.dropDatabase();
    await setup();
    done();
  });
});
