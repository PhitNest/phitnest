import NodeEnvironment from "jest-environment-node";
import mongoose from "mongoose";
import Server from "../server";

class BaseEnvironment extends NodeEnvironment {
  async setup() {
    await super.setup();
    this.global.app = Server;
    const db = mongoose.connection;
    await db.dropDatabase();
  }
}

export default BaseEnvironment;
