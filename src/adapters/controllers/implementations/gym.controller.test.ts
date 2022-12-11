import { compareGym } from "../../../../test/helpers/comparisons";
import { MockRequest, MockResponse } from "../../../../test/mocks";
import {
  Controllers,
  dependencies,
  Repositories,
} from "../../../common/dependency-injection";
import { IGymEntity, IUserEntity, LocationEntity } from "../../../entities";
import { GymModel } from "../../../repositories/implementations/gym.repository";
import { UserModel } from "../../../repositories/implementations/user.repository";
import {
  statusBadRequest,
  statusCreated,
  statusInternalServerError,
  statusOK,
} from "../../../constants/http_codes";
import {
  IGymRepository,
  IUserRepository,
} from "../../../repositories/interfaces";
import { IGymController } from "../interfaces";

const testUser1 = {
  cognitoId: "TestCognitoId",
  email: "TestEmail@gmail.com",
  firstName: "TestFirstName",
  lastName: "TestLastName",
  gymId: "",
};

const testUser2 = {
  cognitoId: "TestCognitoId2",
  email: "testEmail2@gmail.com",
  firstName: "TestFirstName2",
  lastName: "TestLastName2",
  gymId: "",
};

const testGym1 = {
  name: "Planet Fitness",
  address: {
    street: "522 Pine Song Ln",
    city: "Virginia Beach",
    state: "VA",
    zipCode: "23451",
  },
  location: new LocationEntity(-75.996, 36.85),
};

const testGym2 = {
  name: "Gold's Gym",
  address: {
    street: "413 E Roanoke St",
    city: "Blacksburg",
    state: "VA",
    zipCode: "24060",
  },
  location: new LocationEntity(-80.413, 37.229),
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
let userRepo: IUserRepository;
let gymRepo: IGymRepository;

beforeAll(() => {
  gymController = dependencies.get(Controllers.gym);
  userRepo = dependencies.get(Repositories.user);
  gymRepo = dependencies.get(Repositories.gym);
});

describe("Creating a new gym", () => {
  afterAll(async () => {
    await GymModel.deleteMany({});
  });

  test("With empty request body", async () => {
    const mockRequest = new MockRequest();
    const mockResponse = new MockResponse({});
    const res = await gymController.create(mockRequest, mockResponse);
    expect(res.code).toBe(statusBadRequest);
    expect(res.content).toEqual([
      {
        code: "invalid_type",
        expected: "object",
        message: "Required",
        path: [],
        received: "undefined",
      },
    ]);
  });

  test("With invalid request body", async () => {
    let mockRequest = new MockRequest({});
    let mockResponse = new MockResponse({});
    let res = await gymController.create(mockRequest, mockResponse);
    expect(res.code).toBe(statusBadRequest);
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
    mockRequest = new MockRequest({ name: "test", address: "test" });
    mockResponse = new MockResponse({});
    res = await gymController.create(mockRequest, mockResponse);
    expect(res.code).toBe(statusBadRequest);
    expect(res.content).toEqual([
      {
        code: "invalid_type",
        expected: "object",
        message: "Expected object, received string",
        path: ["address"],
        received: "string",
      },
    ]);
    mockRequest = new MockRequest({
      name: "test",
      address: { street: "test" },
    });
    mockResponse = new MockResponse({});
    res = await gymController.create(mockRequest, mockResponse);
    expect(res.code).toBe(statusBadRequest);
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
  });

  test("With invalid address", async () => {
    const mockRequest = new MockRequest(fakeGym);
    const mockResponse = new MockResponse({});
    const res = await gymController.create(mockRequest, mockResponse);
    expect(res.code).toBe(statusInternalServerError);
    expect(res.content).toEqual("Address could not be located");
  });

  test("With valid request body", async () => {
    let mockRequest = new MockRequest({
      name: testGym1.name,
      address: testGym1.address,
    });
    let mockResponse = new MockResponse({});
    let res = await gymController.create(mockRequest, mockResponse);
    expect(res.code).toBe(statusCreated);
    const gym1 = res.content;
    compareGym(gym1, testGym1);
    mockRequest = new MockRequest({
      name: testGym2.name,
      address: testGym2.address,
    });
    mockResponse = new MockResponse({});
    res = await gymController.create(mockRequest, mockResponse);
    expect(res.code).toBe(statusCreated);
    const gym2 = res.content;
    compareGym(gym2, testGym2);
  });
});

describe("Get the nearest gyms", () => {
  let gym1: IGymEntity;
  let gym2: IGymEntity;

  beforeAll(async () => {
    gym1 = await gymRepo.create(testGym1);
    gym2 = await gymRepo.create(testGym2);
    expect(gym1).toBeDefined();
    expect(gym2).toBeDefined();
  });

  afterAll(async () => {
    await GymModel.deleteMany({});
  });

  test("With empty request body", async () => {
    const mockRequest = new MockRequest();
    const mockResponse = new MockResponse({});
    const res = await gymController.getNearest(mockRequest, mockResponse);
    expect(res.code).toBe(statusBadRequest);
    expect(res.content).toEqual([
      {
        code: "invalid_type",
        expected: "object",
        message: "Required",
        path: [],
        received: "undefined",
      },
    ]);
  });

  test("With invalid request body", async () => {
    let mockRequest = new MockRequest({});
    let mockResponse = new MockResponse({});
    let res = await gymController.getNearest(mockRequest, mockResponse);
    expect(res.code).toBe(statusBadRequest);
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
    expect(res.code).toBe(statusBadRequest);
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
    mockRequest = new MockRequest({
      latitude: 91,
      longitude: 181,
      distance: 10,
      amount: 1,
    });
    mockResponse = new MockResponse({});
    res = await gymController.getNearest(mockRequest, mockResponse);
    expect(res.code).toBe(statusBadRequest);
    expect(res.content).toEqual([
      {
        code: "too_big",
        inclusive: true,
        message: "Number must be less than or equal to 180",
        maximum: 180,
        path: ["longitude"],
        type: "number",
      },
      {
        code: "too_big",
        inclusive: true,
        message: "Number must be less than or equal to 90",
        maximum: 90,
        path: ["latitude"],
        type: "number",
      },
    ]);
  });

  test("With valid request body", async () => {
    let mockRequest = new MockRequest({
      latitude: 1,
      longitude: 1,
      distance: 1,
    });
    let mockResponse = new MockResponse({});
    let res = await gymController.getNearest(mockRequest, mockResponse);
    expect(res.code).toBe(statusOK);
    expect(res.content).toEqual([]);
    mockRequest = new MockRequest({
      latitude: 1,
      longitude: 1,
      distance: 10000000,
    });
    mockResponse = new MockResponse({});
    res = await gymController.getNearest(mockRequest, mockResponse);
    expect(res.code).toBe(statusOK);
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
    expect(res.code).toBe(statusOK);
    compareGym(res.content[0], testGym1);
  });
});

describe("Get a gym by user cognito id", () => {
  let user1: IUserEntity;
  let user2: IUserEntity;
  let gym1: IGymEntity;
  let gym2: IGymEntity;

  beforeAll(async () => {
    gym1 = await gymRepo.create(testGym1);
    gym2 = await gymRepo.create(testGym2);
    testUser1.gymId = gym1._id;
    testUser2.gymId = gym2._id;
    user1 = await userRepo.create(testUser1);
    user2 = await userRepo.create(testUser2);
  });

  afterAll(async () => {
    await UserModel.deleteMany({});
    await GymModel.deleteMany({});
  });

  test("Get gym for two distinct users", async () => {
    const mockRequest = new MockRequest();
    let mockResponse = new MockResponse({ cognitoId: user1.cognitoId });
    let res = await gymController.get(mockRequest, mockResponse);
    expect(res.code).toBe(statusOK);
    compareGym(res.content, testGym1);
    mockResponse = new MockResponse({ cognitoId: user2.cognitoId });
    res = await gymController.get(mockRequest, mockResponse);
    expect(res.code).toBe(statusOK);
    compareGym(res.content, testGym2);
  });

  test("Get a gym for a user with an invalid cognito id", async () => {
    const mockRequest = new MockRequest();
    const mockResponse = new MockResponse({ cognitoId: "invalid" });
    const res = await gymController.get(mockRequest, mockResponse);
    expect(res.code).toBe(statusInternalServerError);
    expect(res.content).toEqual("Could not get gym for user with id: invalid");
  });
});
