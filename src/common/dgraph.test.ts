import { Gym, RegistrationStatus, User } from "@/generated/dgraph-schema";
import {
  SchemaType,
  fromPredicateMap,
  toPredicateMap,
  useDgraph,
} from "./dgraph";
const gql = String.raw;

const testGym: SchemaType<Gym> = {
  __typename: "Gym",
  name: "Planet Fitness",
  street: "123 Main St",
  city: "Anytown",
  state: "NY",
  zipCode: "12345",
  location: {
    __typename: "Point",
    latitude: 40.123,
    longitude: -73.456,
  },
};

const gymPredicateMap = {
  "Gym.name": testGym.name,
  "Gym.street": testGym.street,
  "Gym.city": testGym.city,
  "Gym.state": testGym.state,
  "Gym.zipCode": testGym.zipCode,
  "Gym.location": {
    type: "Point",
    coordinates: [testGym.location.longitude, testGym.location.latitude],
  },
};

const userFirstName = "John";
const userLastName = "Doe";
const userRegistrationStatus = RegistrationStatus.Unconfirmed;
const userCreatedAt = Date.now();
const userId = "1";

function getTestUser(gymUid: string): SchemaType<User, "gym"> {
  return {
    __typename: "User",
    firstName: userFirstName,
    lastName: userLastName,
    id: userId,
    registrationStatus: userRegistrationStatus,
    createdAt: userCreatedAt,
    gym: {
      __typename: "Gym",
      uid: gymUid,
    },
  };
}

function getPredicateMapForUser(gymUid: string) {
  return {
    "User.firstName": userFirstName,
    "User.lastName": userLastName,
    "User.id": userId,
    "User.registrationStatus": userRegistrationStatus,
    "User.createdAt": userCreatedAt,
    "User.gym": {
      uid: gymUid,
    },
  };
}

describe("fromPredicateMap", () => {
  it("should throw for invalid points", async () => {
    let invalidPoint = {
      type: "Point",
      coordinates: [0, 0, 0],
    } as any;
    await expect(async () =>
      fromPredicateMap(invalidPoint)
    ).rejects.toThrowError("Invalid coordinates");
    invalidPoint = {
      type: "Point",
      coordinates: [0, 0],
      otherField: "hi",
    };
    await expect(async () =>
      fromPredicateMap(invalidPoint)
    ).rejects.toThrowError("Invalid point");
  });

  it("should throw for invalid typename", async () => {
    const invalidPredicateMap = {
      "User.firstName": userFirstName,
      "User.lastName": userLastName,
      "User.id": userId,
      "User.registrationStatus": userRegistrationStatus,
      "NotUser.createdAt": userCreatedAt,
    };
    await expect(async () =>
      fromPredicateMap(invalidPredicateMap)
    ).rejects.toThrowError("Invalid typename");
  });
});

describe("predicateMap roundtrip", () => {
  const gymUid = "0x1";
  const testUser = getTestUser(gymUid);
  const userPredicateMap = getPredicateMapForUser(gymUid);
  it("toPredicateMap", () => {
    expect(toPredicateMap(testGym)).toEqual(gymPredicateMap);
    expect(toPredicateMap(testUser)).toEqual(userPredicateMap);
  });
  it("fromPredicateMap", () => {
    expect(fromPredicateMap(gymPredicateMap)).toEqual(testGym);
    const userPredicateMapWithExtraGymData = {
      ...userPredicateMap,
      "User.gym": { uid: gymUid, "Gym.name": testGym.name },
    };
    const userWithExtraGymData = {
      ...testUser,
      gym: { __typename: "Gym", uid: gymUid, name: testGym.name },
    };
    expect(fromPredicateMap(userPredicateMapWithExtraGymData)).toEqual(
      userWithExtraGymData
    );
  });
});

describe("useDgraph", () => {
  it("should connect to localhost for test cases", async () => {
    await expect(
      useDgraph(async (client) => {
        const healthResponse = (await client.getHealth()) as any;
        expect(healthResponse).toBeDefined();
        expect(healthResponse).toHaveLength(2);
        expect(healthResponse[0].status).toBe("healthy");
        expect(healthResponse[0].address).toMatch(RegExp("localhost:*"));
        expect(healthResponse[1].status).toBe("healthy");
        expect(healthResponse[1].address).toMatch(RegExp("localhost:*"));
      })
    ).resolves.toBe(void 0);
  });

  it("should pass through return values", async () => {
    const testValue = {
      name: "Hello world",
      details: {
        description: "This is a test",
        value: 42,
      },
    };
    await expect(useDgraph(async () => testValue)).resolves.toBe(testValue);
  });

  it("should allow simple mutations and queries", async () => {
    await expect(
      useDgraph(async (hook) => {
        const gymMutResult = await hook.setJson(testGym);
        const gymUids = Object.keys(gymMutResult.data.uids);
        expect(gymUids).toHaveLength(1);
        const gymUid = gymMutResult.data.uids[gymUids[0]];
        const gymQueryResult = await hook.getJson(
          gql`
            query {
              gymQueryTest(func: eq(Gym.name, "${testGym.name}")) {
                uid
                Gym.name
                Gym.street
                Gym.city
                Gym.state
                Gym.zipCode
                Gym.location
              }
            }
          `
        );
        expect(gymQueryResult["gymQueryTest"]).toBeDefined();
        expect(gymQueryResult["gymQueryTest"]).toHaveLength(1);
        expect(gymQueryResult["gymQueryTest"][0]).toEqual({
          ...testGym,
          uid: gymUid,
        });
        const testUser = getTestUser(gymUid);
        const userMutResult = await hook.setJson(testUser);
        const userUids = Object.keys(userMutResult.data.uids);
        expect(userUids).toHaveLength(1);
        const userUid = userMutResult.data.uids[userUids[0]];
        const userQueryResult = await hook.getJson(
          gql`
            query {
              userQueryTest(func: eq(User.id, "${userId}")) {
                uid
                User.firstName
                User.lastName
                User.id
                User.registrationStatus
                User.createdAt
                User.gym {
                  uid
                  Gym.name
                  Gym.street
                  Gym.city
                  Gym.state
                  Gym.zipCode
                  Gym.location
                }
              }
            }
          `
        );
        expect(userQueryResult["userQueryTest"]).toBeDefined();
        expect(userQueryResult["userQueryTest"]).toHaveLength(1);
        expect(userQueryResult["userQueryTest"][0]).toEqual({
          ...testUser,
          uid: userUid,
          gym: { ...testGym, uid: gymUid },
        });
      })
    ).resolves.toBe(void 0);
  });
});
