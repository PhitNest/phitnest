import { useDgraph } from "../../../common/dgraph";
import { mockGet } from "../../../common/mock";
import { Gym } from "../../../generated/dgraph-schema";
import { invoke } from "./get";

describe("validating GET /gym/all", () => {
  it("should fail for a negative or 0 limit", async () => {
    let response = await invoke(mockGet({ limit: "-10" }));
    expect(response.statusCode).toBe(500);
    expect(JSON.parse(response.body)).toHaveProperty("name", "ZodError");
    response = await invoke(mockGet({ limit: "0" }));
    expect(response.statusCode).toBe(500);
    expect(JSON.parse(response.body)).toHaveProperty("name", "ZodError");
  });

  it("should fail for a negative page", async () => {
    const response = await invoke(mockGet({ page: "-10" }));
    expect(response.statusCode).toBe(500);
    expect(JSON.parse(response.body)).toHaveProperty("name", "ZodError");
  });

  it("should pass for page zero", async () => {
    const response = await invoke(mockGet({ page: "0" }));
    expect(response.statusCode).toBe(200);
    expect(response.body).toBe("[]");
  });
});

describe("GET /gym/all", () => {
  beforeAll(async () => {
    await useDgraph(async (client) => {
      const txn = client.newTxn();
      await txn.mutateGraphQL<Gym>({
        obj: {
          "Gym.name": "Gym 1",
          "Gym.city": "City 1",
          "Gym.state": "State 1",
          "Gym.zipCode": "Zip Code 1",
          "Gym.street": "Street 1",
          "Gym.location": {
            type: "Point",
            coordinates: [20, -20],
          },
        },
        commitNow: false,
      });
      await txn.mutateGraphQL<Gym>({
        obj: {
          "Gym.name": "Gym 2",
          "Gym.city": "City 2",
          "Gym.state": "State 2",
          "Gym.zipCode": "Zip Code 2",
          "Gym.street": "Street 2",
          "Gym.location": {
            type: "Point",
            coordinates: [0, 0],
          },
        },
        commitNow: false,
      });
      await txn.commit();
    });
  });

  it("should return all gyms", async () => {
    const response = await invoke(mockGet());
    expect(response.statusCode).toBe(200);
    const body = JSON.parse(response.body);
    expect(body).toHaveLength(2);
    expect(body[0]).toHaveProperty("__typename", "Gym");
    expect(body[1]).toHaveProperty("__typename", "Gym");
    expect(body[0]).toHaveProperty("name", "Gym 1");
    expect(body[1]).toHaveProperty("name", "Gym 2");
    expect(body[0]).toHaveProperty("city", "City 1");
    expect(body[1]).toHaveProperty("city", "City 2");
    expect(body[0]).toHaveProperty("state", "State 1");
    expect(body[1]).toHaveProperty("state", "State 2");
    expect(body[0]).toHaveProperty("zipCode", "Zip Code 1");
    expect(body[1]).toHaveProperty("zipCode", "Zip Code 2");
    expect(body[0]).toHaveProperty("street", "Street 1");
    expect(body[1]).toHaveProperty("street", "Street 2");
    expect(body[0]).toHaveProperty("location", {
      __typename: "Point",
      longitude: 20,
      latitude: -20,
    });
    expect(body[1]).toHaveProperty("location", {
      __typename: "Point",
      longitude: 0,
      latitude: 0,
    });
  });
});
