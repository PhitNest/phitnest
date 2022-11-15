import supertest, { Response } from "supertest";
import { AddressModel } from "../../server/src/models/address.model";
import { LocationModel } from "../../server/src/models/location.model";
import BaseEnvironment from "../environment";
import { createGym, deleteUser } from "../helpers";
import { testEmail, testPassword } from "./constants";

class AuthTestEnvironment extends BaseEnvironment {
  async setup() {
    await super.setup();
    this.global.gymIds = [
      await createGym(
        "Planet Fitness",
        new AddressModel("413 E Roanoke St", "Blacksburg", "VA", "24060"),
        new LocationModel(-80.4138162, 37.2294115)
      ),
    ];
  }
}

export default AuthTestEnvironment;
