import { compareGym } from "../../../../test/helpers/comparisons";
import { MockRequest, MockResponse } from "../../../../test/mocks";
import {
  Controllers,
  dependencies,
} from "../../../common/dependency-injection";
import { IGymEntity } from "../../../entities";
import { IGymController } from "../interfaces";

const testGym1 = {
  name: "Planet Fitness",
  address: {
    street: "522 Pine Song Ln",
    city: "Virginia Beach",
    state: "VA",
    zipCode: "23451",
  },
  location: {
    type: "Point",
    coordinates: [-75.996, 36.85] as [number, number],
  },
};

const testGym2 = {
  name: "Gold's Gym",
  address: {
    street: "413 E Roanoke St",
    city: "Blacksburg",
    state: "VA",
    zipCode: "24060",
  },
  location: {
    type: "Point",
    coordinates: [-80.413, 37.229] as [number, number],
  },
};

const fakeGym = {
  name: "Fake Gym",
  address: {
    street: "1234 Main St",
    city: "Blacksburg",
    state: "CA",
    zipCode: "25060",
  },
};

let gymController: IGymController;

let gym1: IGymEntity;
let gym2: IGymEntity;

beforeAll(() => {
  gymController = dependencies.get(Controllers.gym);
});

test("Can create a new gym", async () => {
  let mockRequest = new MockRequest();
  let mockResponse = new MockResponse({});
  let res = await gymController.create(mockRequest, mockResponse);
  expect(res.code).toBe(400);
  expect(res.content).toEqual([
    {
      code: "invalid_type",
      expected: "object",
      message: "Required",
      path: [],
      received: "undefined",
    },
  ]);
  mockRequest = new MockRequest({});
  mockResponse = new MockResponse({});
  res = await gymController.create(mockRequest, mockResponse);
  expect(res.code).toBe(400);
  expect(res.content).toEqual([
    {
      code: "invalid_type",
      expected: "string",
      message: "Required",
      path: ["name"],
      received: "undefined",
    },
    {
      code: "invalid_type",
      expected: "object",
      message: "Required",
      path: ["address"],
      received: "undefined",
    },
  ]);
  mockRequest = new MockRequest({ name: "test" });
  mockResponse = new MockResponse({});
  res = await gymController.create(mockRequest, mockResponse);
  expect(res.code).toBe(400);
  expect(res.content).toEqual([
    {
      code: "invalid_type",
      expected: "object",
      message: "Required",
      path: ["address"],
      received: "undefined",
    },
  ]);
  mockRequest = new MockRequest({ name: "test", address: "test" });
  mockResponse = new MockResponse({});
  res = await gymController.create(mockRequest, mockResponse);
  expect(res.code).toBe(400);
  expect(res.content).toEqual([
    {
      code: "invalid_type",
      expected: "object",
      message: "Expected object, received string",
      path: ["address"],
      received: "string",
    },
  ]);
  mockRequest = new MockRequest({ name: "test", address: { street: "test" } });
  mockResponse = new MockResponse({});
  res = await gymController.create(mockRequest, mockResponse);
  expect(res.code).toBe(400);
  expect(res.content).toEqual([
    {
      code: "invalid_type",
      expected: "string",
      message: "Required",
      path: ["address", "city"],
      received: "undefined",
    },
    {
      code: "invalid_type",
      expected: "string",
      message: "Required",
      path: ["address", "state"],
      received: "undefined",
    },
    {
      code: "invalid_type",
      expected: "string",
      message: "Required",
      path: ["address", "zipCode"],
      received: "undefined",
    },
  ]);
  mockRequest = new MockRequest(fakeGym);
  mockResponse = new MockResponse({});
  res = await gymController.create(mockRequest, mockResponse);
  expect(res.code).toBe(500);
  expect(res.content).toEqual({ message: "Address could not be located" });
  mockRequest = new MockRequest({
    name: testGym1.name,
    address: testGym1.address,
  });
  mockResponse = new MockResponse({});
  res = await gymController.create(mockRequest, mockResponse);
  expect(res.code).toBe(200);
  gym1 = res.content;
  compareGym(gym1, testGym1);
  mockRequest = new MockRequest({
    name: testGym2.name,
    address: testGym2.address,
  });
  mockResponse = new MockResponse({});
  res = await gymController.create(mockRequest, mockResponse);
  expect(res.code).toBe(200);
  gym2 = res.content;
  compareGym(gym2, testGym2);
});

test("Can get the nearest gyms", async () => {
  expect(gym1).toBeDefined();
  expect(gym2).toBeDefined();
  let mockRequest = new MockRequest();
  let mockResponse = new MockResponse({});
  let res = await gymController.getNearest(mockRequest, mockResponse);
  expect(res.code).toBe(400);
  expect(res.content).toEqual([
    {
      code: "invalid_type",
      expected: "object",
      message: "Required",
      path: [],
      received: "undefined",
    },
  ]);
  mockRequest = new MockRequest({});
  mockResponse = new MockResponse({});
  res = await gymController.getNearest(mockRequest, mockResponse);
  expect(res.code).toBe(400);
  expect(res.content).toEqual([
    {
      code: "invalid_type",
      expected: "number",
      message: "Required",
      path: ["longitude"],
      received: "undefined",
    },
    {
      code: "invalid_type",
      expected: "number",
      message: "Required",
      path: ["latitude"],
      received: "undefined",
    },
    {
      code: "invalid_type",
      expected: "number",
      message: "Required",
      path: ["distance"],
      received: "undefined",
    },
  ]);
  mockRequest = new MockRequest({
    latitude: -91,
    longitude: -181,
    distance: -10,
    amount: -1,
  });
  mockResponse = new MockResponse({});
  res = await gymController.getNearest(mockRequest, mockResponse);
  expect(res.code).toBe(400);
  expect(res.content).toEqual([
    {
      code: "too_small",
      inclusive: true,
      message: "Number must be greater than or equal to -180",
      minimum: -180,
      path: ["longitude"],
      type: "number",
    },
    {
      code: "too_small",
      inclusive: true,
      message: "Number must be greater than or equal to -90",
      minimum: -90,
      path: ["latitude"],
      type: "number",
    },
    {
      code: "too_small",
      inclusive: false,
      message: "Number must be greater than 0",
      minimum: 0,
      path: ["distance"],
      type: "number",
    },
    {
      code: "too_small",
      inclusive: false,
      message: "Number must be greater than 0",
      minimum: 0,
      path: ["amount"],
      type: "number",
    },
  ]);
  mockRequest = new MockRequest({ latitude: 1, longitude: 1, distance: 1 });
  mockResponse = new MockResponse({});
  res = await gymController.getNearest(mockRequest, mockResponse);
  expect(res.code).toBe(200);
  expect(res.content).toEqual([]);
  mockRequest = new MockRequest({
    latitude: 1,
    longitude: 1,
    distance: 10000000,
  });
  mockResponse = new MockResponse({});
  res = await gymController.getNearest(mockRequest, mockResponse);
  expect(res.code).toBe(200);
  compareGym(res.content[0], testGym1);
  compareGym(res.content[1], testGym2);
  mockRequest = new MockRequest({
    latitude: 1,
    longitude: 1,
    distance: 10000000,
    amount: 1,
  });
  mockResponse = new MockResponse({});
  res = await gymController.getNearest(mockRequest, mockResponse);
  expect(res.code).toBe(200);
  compareGym(res.content[0], testGym1);
});

test("TODO: Can get a gym by user id", async () => {});
