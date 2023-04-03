import { Gym } from "@/generated/dgraph-schema";
import { toPredicateMap, useDgraph } from "./dgraph";
const gql = String.raw;

describe("toPredicateMap", () => {
  it("should convert a simple object", () => {
    const name = "Planet Fitness";
    const street = "123 Main St";
    const city = "Anytown";
    const state = "NY";
    const zipCode = "12345";
    const latitude = 40.123;
    const longitude = -73.456;
    const gym: Partial<Gym> = {
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
    expect(toPredicateMap(gym)).toEqual({
      "Gym.name": name,
      "Gym.street": street,
      "Gym.city": city,
      "Gym.state": state,
      "Gym.zipCode": zipCode,
      "Gym.location": {
        type: "Point",
        coordinates: [longitude, latitude],
      },
    });
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
        const gym: Partial<Gym> = {
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
        const [, uid] = Object.entries(mutResult.data.uids)[0];
        expect(
          (
            (
              await hook.newTxn().query(
                gql`
                  query {
                    queryTest(func: eq(Gym.name, "Planet Fitness")) {
                      uid,
                      Gym.name
                      Gym.street
                      Gym.city
                      Gym.state
                      Gym.zipCode
                      Gym.location
                    }
                  }
                `
              )
            ).data as any
          ).queryTest[0]
        ).toEqual({
          uid: uid,
          ...toPredicateMap(gym),
        });
      })
    ).resolves.toBe(void 0);
  });
});
