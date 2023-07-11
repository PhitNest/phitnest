import { SerializedDynamo, parseDynamo } from "./dynamo";
import {
  Gym,
  GymWithoutAdmin,
  gymToDynamo,
  gymWithoutAdminToDynamo,
  kGymParser,
  kGymWithoutAdminParser,
} from "./gym";

const testGymWithoutAdmin: GymWithoutAdmin = {
  id: "1",
  gymName: "test",
  createdAt: new Date(Date.UTC(2020, 1, 1)),
  address: {
    street: "street",
    city: "city",
    state: "state",
    zipCode: "zip",
  },
  gymLocation: {
    latitude: 1,
    longitude: 1,
  },
};

const serializedGymWithoutAdmin: SerializedDynamo<GymWithoutAdmin> = {
  id: { S: "1" },
  gymName: { S: "test" },
  createdAt: { N: Date.UTC(2020, 1, 1).toString() },
  address: {
    M: {
      street: { S: "street" },
      city: { S: "city" },
      state: { S: "state" },
      zipCode: { S: "zip" },
    },
  },
  gymLocation: {
    M: {
      latitude: { N: "1" },
      longitude: { N: "1" },
    },
  },
};

const testGym: Gym = {
  ...testGymWithoutAdmin,
  adminEmail: "adminEmail",
};

const serializedGym: SerializedDynamo<Gym> = {
  ...serializedGymWithoutAdmin,
  adminEmail: { S: "adminEmail" },
};

describe("GymWithoutAdmin", () => {
  it("serializes to dynamo", () => {
    expect(gymWithoutAdminToDynamo(testGymWithoutAdmin)).toEqual(
      serializedGymWithoutAdmin
    );
  });

  it("deserializes from dynamo", () => {
    expect(
      parseDynamo(serializedGymWithoutAdmin, kGymWithoutAdminParser)
    ).toEqual(testGymWithoutAdmin);
  });
});

describe("Gym", () => {
  it("serializes to dynamo", () => {
    expect(gymToDynamo(testGym)).toEqual(serializedGym);
  });

  it("deserializes from dynamo", () => {
    expect(parseDynamo(serializedGym, kGymParser)).toEqual(testGym);
  });
});
