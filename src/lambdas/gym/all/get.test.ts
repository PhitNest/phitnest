import { useDgraph } from "../../../common/dgraph";
import { mockGet } from "../../../testing/mock";
import { Gym } from "../../../generated/dgraph-schema";
import { invoke } from "./get";
import { MAX_PAGE_LENGTH } from "../../../common/zod-schema";

describe("validating GET /gym/all", () => {
  it("should fail for a negative or 0 limit", async () => {
    let response = await invoke(mockGet({}, { limit: "-10" }));
    expect(response.statusCode).toBe(500);
    expect(JSON.parse(response.body)).toHaveProperty("name", "ZodError");
    response = await invoke(mockGet({}, { limit: "0" }));
    expect(response.statusCode).toBe(500);
    expect(JSON.parse(response.body)).toHaveProperty("name", "ZodError");
  });

  it("should fail for a negative page", async () => {
    const response = await invoke(mockGet({}, { page: "-10" }));
    expect(response.statusCode).toBe(500);
    expect(JSON.parse(response.body)).toHaveProperty("name", "ZodError");
  });

  it("should pass for page zero", async () => {
    const response = await invoke(mockGet({}, { page: "0" }));
    expect(response.statusCode).toBe(200);
    const parsedBody = JSON.parse(response.body);
    expect(parsedBody).toHaveProperty("gyms", []);
    expect(parsedBody).toHaveProperty("count", 0);
  });
});

const NUM_TEST_GYMS = 51;

const testGyms: Gym[] = Array(NUM_TEST_GYMS)
  .fill(void 0, 0, NUM_TEST_GYMS)
  .map((_, i) => {
    return {
      __typename: "Gym",
      name: `Gym${i}`,
      city: `City${i}`,
      state: `State${i}`,
      zipCode: `ZipCode${i}`,
      street: `Street${i}`,
      location: {
        __typename: "Point",
        latitude: i,
        longitude: i === 0 ? 0 : -i,
      },
    };
  });

describe("GET /gym/all", () => {
  beforeEach(async () => {
    await useDgraph(async (client) => {
      const txn = client.newTxn();
      for (const gym of testGyms) {
        await txn.mutate<Gym>({
          obj: {
            "Gym.name": gym.name,
            "Gym.city": gym.city,
            "Gym.state": gym.state,
            "Gym.zipCode": gym.zipCode,
            "Gym.street": gym.street,
            "Gym.location": {
              type: "Point",
              coordinates: [gym.location.longitude, gym.location.latitude],
            },
          },
          commitNow: false,
        });
      }
      await txn.commit();
    });
  });

  it("should return first MAX_PAGE_LENGTH gyms", async () => {
    const response = await invoke(mockGet());
    expect(response.statusCode).toBe(200);
    const body = JSON.parse(response.body);
    expect(body.gyms).toHaveLength(MAX_PAGE_LENGTH);
    expect(body.gyms).toMatchObject<Gym[]>(testGyms.slice(0, MAX_PAGE_LENGTH));
    expect(body.count).toBe(NUM_TEST_GYMS);
  });

  it("should return the first half of the test gyms", async () => {
    const half = Math.round(NUM_TEST_GYMS / 2);
    const response = await invoke(mockGet({}, { limit: half.toString() }));
    expect(response.statusCode).toBe(200);
    const body = JSON.parse(response.body);
    expect(body.gyms).toHaveLength(half);
    expect(body.gyms).toMatchObject<Gym[]>(testGyms.slice(0, half));
    expect(body.count).toBe(NUM_TEST_GYMS);
  });

  it("should return 10 gyms from the middle", async () => {
    const limit = 10;
    const skip = Math.floor((NUM_TEST_GYMS - limit) / 2);
    const response = await invoke(
      mockGet(
        {},
        { limit: limit.toString(), page: Math.floor(skip / limit).toString() }
      )
    );
    expect(response.statusCode).toBe(200);
    const body = JSON.parse(response.body);
    expect(body.gyms).toHaveLength(limit);
    expect(body.gyms).toMatchObject<Gym[]>(testGyms.slice(skip, skip + limit));
    expect(body.count).toBe(NUM_TEST_GYMS);
  });

  it("should return last gym", async () => {
    const limit = 1;
    const skip = NUM_TEST_GYMS - limit;
    const response = await invoke(
      mockGet(
        {},
        { limit: limit.toString(), page: Math.ceil(skip / limit).toString() }
      )
    );
    expect(response.statusCode).toBe(200);
    const body = JSON.parse(response.body);
    expect(body.gyms).toHaveLength(limit);
    expect(body.gyms).toMatchObject<Gym[]>(testGyms.slice(skip));
    expect(body.count).toBe(NUM_TEST_GYMS);
  });

  it("should return first 3 gyms using search query", async () => {
    const response = await invoke(
      mockGet({}, { searchQuery: "State0 City1 ZipCode2" })
    );
    expect(response.statusCode).toBe(200);
    const body = JSON.parse(response.body);
    expect(body.gyms).toHaveLength(3);
    expect(body.gyms).toMatchObject<Gym[]>(testGyms.slice(0, 3));
    expect(body.count).toBe(3);
  });

  it("should return first Gym2 and Gym3 using search query", async () => {
    const response = await invoke(
      mockGet(
        {},
        {
          searchQuery: "State0 City1 ZipCode2 State3 ZipCode3 City3 Gym4",
          limit: "2",
          page: "1",
        }
      )
    );
    expect(response.statusCode).toBe(200);
    const body = JSON.parse(response.body);
    expect(body.gyms).toHaveLength(2);
    expect(body.gyms).toMatchObject<Gym[]>(testGyms.slice(2, 4));
    expect(body.count).toBe(5);
  });
});
