const RestEnvironment = require("../environment");
const { createUser } = require("../../../lib/models");

const userPayload = {
  email: "a@b.com",
  password: "$2a$10$V603PA18aLlRnD1gzdM9mOfekYyK9D/fvlAFIQEASdKDmGdHFE2ne",
  firstName: "Joe",
  mobile: "7577481868",
  birthday: Date.UTC(2000, 1, 1),
  lastSeen: Date.now(),
};

class AuthEnvironment extends RestEnvironment {
  async setup() {
    await super.setup();
    this.global.data = { createdUser: await createUser(userPayload) };
  }
}

module.exports = AuthEnvironment;
