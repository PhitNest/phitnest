import { UNABLE_TO_FIND_LOCATION, invoke } from "./post";
import { mockPost } from "api/common/test-helpers";
import * as uuid from "uuid";

const testAddress1 = {
  street: "522 Pine Song Ln",
  city: "Virginia Beach",
  state: "VA",
  zipCode: "23451",
};

describe("POST /gym", () => {
  it("should fail for invalid input", async () => {
    expect(await invoke(mockPost(undefined))).toEqual({
      statusCode: 400,
      headers: {
        "Content-Type": "application/json",
      },
      body: JSON.stringify({
        message:
          "name: Required, street: Required, city: Required, state: Required, zipCode: Required",
      }),
    });
  });

  it("should fail for invalid address", async () => {
    const result = await invoke(
      mockPost({
        name: "test",
        street: "123 Fake St",
        city: "Blacksburg",
        state: "ZA",
        zipCode: "44160",
      })
    );
    expect(result).toEqual({
      statusCode: 500,
      headers: {
        "Content-Type": "application/json",
      },
      body: JSON.stringify(UNABLE_TO_FIND_LOCATION),
    });
  });

  it("should create a gym when used with valid input", async () => {
    const uuidSpy = jest.spyOn(uuid, "v4");
    const result = await invoke(
      mockPost({
        name: "test",
        ...testAddress1,
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
  });
});
