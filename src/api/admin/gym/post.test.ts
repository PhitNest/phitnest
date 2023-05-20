import { UNABLE_TO_FIND_LOCATION_MSG, invoke } from "./post";
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
    const emptyBodyResult = await invoke(mockPost(undefined));
    expect(emptyBodyResult).toEqual({
      statusCode: 400,
      headers: {
        "Content-Type": "application/json",
      },
      body: JSON.stringify([
        {
          code: "invalid_type",
          expected: "string",
          received: "undefined",
          path: ["name"],
          message: "Required",
        },
        {
          code: "invalid_type",
          expected: "string",
          received: "undefined",
          path: ["street"],
          message: "Required",
        },
        {
          code: "invalid_type",
          expected: "string",
          received: "undefined",
          path: ["city"],
          message: "Required",
        },
        {
          code: "invalid_type",
          expected: "string",
          received: "undefined",
          path: ["state"],
          message: "Required",
        },
        {
          code: "invalid_type",
          expected: "string",
          received: "undefined",
          path: ["zipCode"],
          message: "Required",
        },
      ]),
    });
    const result = await invoke(
      mockPost({
        name: "test",
        street: "123 Fake St",
        city: "Blacksburg",
        state: "VA",
      })
    );
    expect(result).toEqual({
      statusCode: 400,
      headers: {
        "Content-Type": "application/json",
      },
      body: JSON.stringify([
        {
          code: "invalid_type",
          expected: "string",
          received: "undefined",
          path: ["zipCode"],
          message: "Required",
        },
      ]),
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
        "Content-Type": "text/plain",
      },
      body: UNABLE_TO_FIND_LOCATION_MSG,
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
