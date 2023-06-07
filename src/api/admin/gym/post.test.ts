import { kGymDynamo } from "api/common/entities";
import { invoke } from "./post";
import { mockPost } from "api/common/test-helpers";
import { dynamo, kInvalidParameter, kZodError } from "api/common/utils";
import * as uuid from "uuid";

const testAddress1 = {
  street: "522 Pine Song Ln",
  city: "Virginia Beach",
  state: "VA",
  zipCode: "23451",
};

describe("POST /gym", () => {
  it("should fail for invalid input", async () => {
    expect(await invoke(mockPost({}))).toEqual({
      statusCode: 500,
      headers: {
        "Content-Type": "application/json",
      },
      body: JSON.stringify({
        type: kZodError,
        message:
          "name: Required, adminEmail: Required, street: Required, city: Required, state: Required, zipCode: Required",
      }),
    });
  });

  it("should fail for invalid address", async () => {
    const result = await invoke(
      mockPost({
        body: {
          name: "test",
          street: "123 Fake St",
          city: "Blacksburg",
          state: "ZA",
          zipCode: "44160",
        },
        authClaims: {
          email: "something",
          sub: "something",
        },
      })
    );
    expect(JSON.parse(result.body).type).toEqual(kInvalidParameter);
  });

  it("should create a gym when used with valid input", async () => {
    const uuidSpy = jest.spyOn(uuid, "v4");
    const adminEmail = "test@gmail.com";
    const result = await invoke(
      mockPost({
        body: {
          name: "test",
          ...testAddress1,
        },
        authClaims: {
          sub: "test",
          email: adminEmail,
        },
      })
    );
    const body = JSON.parse(result.body);
    expect(body.location).toBeDefined();
    expect(body.location.longitude).toBeCloseTo(-75.996, 2);
    expect(body.location.latitude).toBeCloseTo(36.85, 2);
    expect(uuidSpy).toBeCalledTimes(1);
    const uuidResult = uuidSpy.mock.results[0];
    expect(uuidResult.type).toBe("return");
    const gymId = uuidResult.value;
    expect(body.gymId).toBe(gymId);
    expect(result.statusCode).toBe(200);
    const queryTestGym = await dynamo()
      .connect()
      .parsedQuery({
        pk: "GYMS",
        sk: { q: `GYMS#`, op: "BEGINS_WITH" },
        parseShape: kGymDynamo,
      });
    expect(queryTestGym).toHaveLength(1);
    const gymRes = queryTestGym[0];
    expect(gymRes.id).toBe(gymId);
    expect(gymRes.name).toBe("test");
    expect(gymRes.address).toEqual(testAddress1);
    expect(gymRes.adminEmail).toBe(adminEmail);
    expect(gymRes.location).toEqual(body.location);
    expect(gymRes.createdAt).toBeDefined();
  });
});
