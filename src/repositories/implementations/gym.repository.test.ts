import { compareGym } from "../../../test/helpers/comparisons";
import { dependencies, Repositories } from "../../common/dependency-injection";
import { IGymEntity, IUserEntity, LocationEntity } from "../../entities";
import { IGymRepository, IUserRepository } from "../interfaces";

const testGym1 = {
  name: "TestGym1",
  address: {
    street: "TestStreet1",
    city: "TestCity1",
    state: "TestState1",
    zipCode: "TestZipCode1",
  },
  location: new LocationEntity(50, 40),
};

const testGym2 = {
  name: "TestGym2",
  address: {
    street: "TestStreet2",
    city: "TestCity2",
    state: "TestState2",
    zipCode: "TestZipCode2",
  },
  location: new LocationEntity(50, -40),
};

const testGym3 = {
  name: "TestGym3",
  address: {
    street: "TestStreet3",
    city: "TestCity3",
    state: "TestState3",
    zipCode: "TestZipCode3",
  },
  location: new LocationEntity(20, -40),
};

const testUser1 = {
  cognitoId: "TestCognitoId",
  email: "TestEmail",
  firstName: "TestFirstName",
  lastName: "TestLastName",
  gymId: "",
};

const testUser2 = {
  cognitoId: "TestCognitoId2",
  email: "TestEmail2@gmail.com",
  firstName: "TestFirstName2",
  lastName: "TestLastName2",
  gymId: "",
};

let gym1: IGymEntity;
let gym2: IGymEntity;
let gym3: IGymEntity;
let user1: IUserEntity;
let user2: IUserEntity;

let gymRepo: IGymRepository;
let userRepo: IUserRepository;

test("Gyms can be created", async () => {
  gymRepo = dependencies.get(Repositories.gym);
  userRepo = dependencies.get(Repositories.user);
  gym1 = await gymRepo.create(testGym1);
  compareGym(gym1, testGym1);
  gym2 = await gymRepo.create(testGym2);
  compareGym(gym2, testGym2);
  gym3 = await gymRepo.create(testGym3);
  compareGym(gym3, testGym3);
});

test("Get a users gym", async () => {
  expect(gym1).toBeDefined();
  expect(gym2).toBeDefined();
  expect(gym3).toBeDefined();
  testUser1.gymId = gym1._id;
  user1 = await userRepo.create(testUser1);
  expect(await gymRepo.getByUser("fake gym")).toBeNull();
  const myGym1 = await gymRepo.getByUser(user1.cognitoId);
  expect(myGym1).toBeDefined();
  compareGym(myGym1!, gym1);
  testUser2.gymId = gym2._id;
  user2 = await userRepo.create(testUser2);
  const myGym2 = await gymRepo.getByUser(user2.cognitoId);
  expect(myGym2).toBeDefined();
  compareGym(myGym2!, gym2);
});

test("Get the nearest gyms", async () => {
  expect(gym1).toBeDefined();
  expect(gym2).toBeDefined();
  let nearestGyms = await gymRepo.getNearest(
    new LocationEntity(50.1, 40.1),
    10000
  );
  expect(nearestGyms).toBeDefined();
  expect(nearestGyms.length).toBe(0);
  nearestGyms = await gymRepo.getNearest(
    new LocationEntity(50.1, 40.1),
    200000
  );
  expect(nearestGyms.length).toBe(1);
  compareGym(nearestGyms[0], gym1);
  nearestGyms = await gymRepo.getNearest(
    new LocationEntity(50.1, 40.1),
    9000000
  );
  expect(nearestGyms.length).toBe(2);
  compareGym(nearestGyms[0], gym1);
  compareGym(nearestGyms[1], gym2);
  nearestGyms = await gymRepo.getNearest(
    new LocationEntity(50.1, 40.1),
    9000000,
    1
  );
  expect(nearestGyms.length).toBe(1);
  compareGym(nearestGyms[0], gym1);
  nearestGyms = await gymRepo.getNearest(
    new LocationEntity(50.1, 40.1),
    9000000,
    0
  );
  expect(nearestGyms.length).toBe(0);
});
