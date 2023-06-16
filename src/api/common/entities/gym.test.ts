import { Dynamo, parseDynamo } from "./dynamo";
import { Gym, gymToDynamo, kGymDynamo } from "./gym";

const testGym: Gym = {
  id: "1",
  gymName: "test",
  createdAt: new Date(Date.UTC(2020, 1, 1)),
  address: {
    street: "street",
    city: "city",
    state: "state",
    zipCode: "zip",
  },
  location: {
    latitude: 1,
    longitude: 1,
  },
  adminEmail: "adminEmail",
};

const serializedGym: Dynamo<Gym> = {
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
  location: {
    M: {
      latitude: { N: "1" },
      longitude: { N: "1" },
    },
  },
  adminEmail: { S: "adminEmail" },
};

describe("Gym", () => {
  it("serializes to dynamo", () => {
    expect(gymToDynamo(testGym)).toEqual(serializedGym);
  });

  it("deserializes from dynamo", () => {
    expect(parseDynamo(serializedGym, kGymDynamo)).toEqual(testGym);
  });
});
