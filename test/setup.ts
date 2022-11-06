import "mocha";
import {testGym, testUser} from "./constants"
import mongoose from "mongoose";

// clear database after connected
before(function (done) {
  this.timeout(15000);
  const db = mongoose.connection;
  db.once("open", async () => {
    await db.dropDatabase();
    // Create a test user manually, this user should already exist within cognito
    await testGym.save();
    await testUser.save();
    done();
  });
});
