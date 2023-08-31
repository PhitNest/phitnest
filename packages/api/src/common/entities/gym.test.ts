import { SerializedDynamo, parseDynamo } from "./dynamo";
import { Gym, gymToDynamo, kGymParser } from "./gym";

const kTestGym: Gym = {
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
  adminEmail: "adminEmail",
};

const kSerializedGym: SerializedDynamo<Gym> = {
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
  adminEmail: { S: "adminEmail" },
};

describe("Gym", () => {
  it("serializes to dynamo", () => {
    expect(gymToDynamo(kTestGym)).toEqual(kSerializedGym);
  });

  it("deserializes from dynamo", () => {
    expect(parseDynamo(kSerializedGym, kGymParser)).toEqual(kTestGym);
  });
});
