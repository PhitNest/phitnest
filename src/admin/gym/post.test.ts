import { Address, kGymParser } from "common/entities";
import { invoke } from "./post";
import { mockPost } from "common/test-helpers";
import {
  OpenStreetMapError,
  RequestError,
  dynamo,
  kOpenStreetMapErrorType,
  kZodErrorType,
} from "common/utils";
import * as uuid from "uuid";

const testAddress1 = {
  street: "522 Pine Song Ln",
  city: "Virginia Beach",
  state: "VA",
  zipCode: "23451",
};

const fakeAddress = {
  name: "test",
  street: "123 Fake St",
  city: "Blacksburg",
  state: "ZA",
  zipCode: "44160",
};

// Mock getLocation
jest.mock("common/utils", () => {
  const originalModule = jest.requireActual("common/utils");
  return {
    __esModule: true,
    ...originalModule,
    getLocation: jest.fn(async (address: Address) => {
      if (address.state === "ZA") {
        return new OpenStreetMapError();
      }
      return {
        longitude: -75.996,
        latitude: 36.85,
      };
    }),
  };
});

describe("POST /gym", () => {
  it("should fail for invalid input", async () => {
    expect(await invoke(mockPost({}))).toEqual({
      statusCode: 500,
      headers: {
        "Content-Type": "application/json",
      },
      body: JSON.stringify({
        type: kZodErrorType,
        message:
          "name: Required, street: Required, city: Required, state: Required, zipCode: Required",
      }),
    });
  });

  it("should fail for invalid address", async () => {
    const result = await invoke(
      mockPost({
        body: fakeAddress,
        authClaims: {
          email: "something",
          sub: "something",
        },
      })
    );
    expect(JSON.parse(result.body).type).toBe(kOpenStreetMapErrorType);
  });

  it("should create a gym when used with valid input", async () => {
    const uuidSpy = jest.spyOn(uuid, "v4");
    const adminEmail = "test@gmail.com";
    const gymName = "test";
    const result = await invoke(
      mockPost({
        body: {
          name: gymName,
          ...testAddress1,
        },
        authClaims: {
          sub: "test",
          email: adminEmail,
        },
      })
    );
    expect(result.statusCode).toBe(200);
    expect(result.headers).toBeDefined();
    expect(result.headers ? result.headers["Content-Type"] : fail()).toBe(
      "application/json"
    );
    const body = JSON.parse(result.body);
    expect(body.location).toBeDefined();
    expect(body.location.longitude).toEqual(-75.996);
    expect(body.location.latitude).toEqual(36.85);
    expect(uuidSpy).toBeCalledTimes(1);
    const uuidResult = uuidSpy.mock.results[0];
    expect(uuidResult.type).toBe("return");
    const gymId = uuidResult.value;
    expect(body.gymId).toBe(gymId);
    const queryTestGym = await dynamo()
      .connect()
      .parsedQuery({
        pk: "GYMS",
        sk: { q: `GYMS#`, op: "BEGINS_WITH" },
        parseShape: kGymParser,
      });
    expect(queryTestGym).toHaveLength(1);
    if (queryTestGym instanceof RequestError) {
      fail();
    } else {
      const gymRes = queryTestGym[0];
      expect(gymRes.id).toBe(gymId);
      expect(gymRes.gymName).toBe(gymName);
      expect(gymRes.address).toEqual(testAddress1);
      expect(gymRes.adminEmail).toBe(adminEmail);
      expect(gymRes.gymLocation).toEqual(body.location);
      expect(gymRes.createdAt).toBeDefined();
    }
  });
});
