import { Gym } from "@/generated/dgraph-schema";
import {
  SchemaType,
  fromPredicateMap,
  toPredicateMap,
  useDgraph,
} from "./dgraph";
const gql = String.raw;

describe("predicateMap roundtrip", () => {
  const name = "Planet Fitness";
  const street = "123 Main St";
  const city = "Anytown";
  const state = "NY";
  const zipCode = "12345";
  const latitude = 40.123;
  const longitude = -73.456;
  const gym: Omit<SchemaType<Gym>, "id"> = {
    __typename: "Gym",
    name: name,
    street: street,
    city: city,
    state: state,
    zipCode: zipCode,
    location: {
      __typename: "Point",
      latitude: latitude,
      longitude: longitude,
    },
  };
  const predicateMap = {
    "Gym.name": name,
    "Gym.street": street,
    "Gym.city": city,
    "Gym.state": state,
    "Gym.zipCode": zipCode,
    "Gym.location": {
      type: "Point",
      coordinates: [longitude, latitude],
    },
  };
  it("toPredicateMap", () => {
    expect(toPredicateMap(gym)).toEqual(predicateMap);
  });
  it("fromPredicateMap", () => {
    expect(fromPredicateMap(predicateMap)).toEqual(gym);
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
        const name = "Planet Fitness";
        const gym: Omit<SchemaType<Gym>, "id"> = {
          __typename: "Gym",
          name: name,
          street: "123 Main St",
          city: "Anytown",
          state: "NY",
          zipCode: "12345",
          location: {
            __typename: "Point",
            latitude: 40.73061,
            longitude: -73.935242,
          },
        };
        const mutResult = await hook.setJson(gym);
        expect(Object.keys(mutResult.data.uids)).toHaveLength(1);
        const queryResult = await hook.getJson(
          gql`
            query {
              queryTest(func: eq(Gym.name, "Planet Fitness")) {
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
        expect(queryResult["queryTest"]).toBeDefined();
        expect(queryResult["queryTest"]).toHaveLength(1);
        expect(queryResult["queryTest"][0]).toEqual(gym);
      })
    ).resolves.toBe(void 0);
  });
});
