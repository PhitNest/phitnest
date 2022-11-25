import mongoose from "mongoose";
import {
  compareAddress,
  compareLocation,
} from "../../../test/helpers/comparisons";
import { dependencies, Repositories } from "../../common/dependency-injection";
import {
  IAddressEntity,
  IGymEntity,
  ILocationEntity,
  IUserEntity,
} from "../../entities";
import { IGymRepository, IUserRepository } from "../interfaces";

const gymName1 = "TestGym1";
const gymAddress1: IAddressEntity = {
  street: "TestStreet1",
  city: "TestCity1",
  state: "TestState1",
  zipCode: "TestZipCode1",
};
const gymLocation1: ILocationEntity = { type: "Point", coordinates: [50, 40] };
const gymName2 = "TestGym2";
const gymAddress2: IAddressEntity = {
  street: "TestStreet2",
  city: "TestCity2",
  state: "TestState2",
  zipCode: "TestZipCode2",
};
const gymLocation2: ILocationEntity = { type: "Point", coordinates: [50, -40] };
const gymName3 = "TestGym3";
const gymAddress3: IAddressEntity = {
  street: "TestStreet3",
  city: "TestCity3",
  state: "TestState3",
  zipCode: "TestZipCode3",
};
const gymLocation3: ILocationEntity = { type: "Point", coordinates: [20, -40] };

const testUser1 = {
  cognitoId: "TestCognitoId",
  email: "TestEmail",
  firstName: "TestFirstName",
  lastName: "TestLastName",
  gymId: undefined as mongoose.Types.ObjectId | undefined,
};

const testUser2 = {
  cognitoId: "TestCognitoId2",
  email: "TestEmail2@gmail.com",
  firstName: "TestFirstName2",
  lastName: "TestLastName2",
  gymId: undefined as mongoose.Types.ObjectId | undefined,
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
  gym1 = await gymRepo.create(gymName1, gymAddress1, gymLocation1);
  expect(gym1).toBeDefined();
  expect(gym1.name).toBe(gymName1);
  compareAddress(gym1.address, gymAddress1);
  compareLocation(gym1.location, gymLocation1);
  gym2 = await gymRepo.create(gymName2, gymAddress2, gymLocation2);
  expect(gym2).toBeDefined();
  expect(gym2.name).toBe(gymName2);
  compareAddress(gym2.address, gymAddress2);
  compareLocation(gym2.location, gymLocation2);
  gym3 = await gymRepo.create(gymName3, gymAddress3, gymLocation3);
  expect(gym3).toBeDefined();
  expect(gym3.name).toBe(gymName3);
  compareAddress(gym3.address, gymAddress3);
  compareLocation(gym3.location, gymLocation3);
});

test("Get a users gym", async () => {
  userRepo = dependencies.get(Repositories.user);
  testUser1.gymId = gym1._id;
  user1 = await userRepo.create(
    testUser1.cognitoId,
    testUser1.email,
    testUser1.gymId!,
    testUser1.firstName,
    testUser1.lastName
  );
  const myGym1 = await gymRepo.get(user1.cognitoId);
  expect(myGym1).toBeDefined();
  expect(myGym1._id).toEqual(gym1._id);
  expect(myGym1.name).toBe(gymName1);
  compareAddress(myGym1.address, gymAddress1);
  compareLocation(myGym1.location, gymLocation1);
  testUser2.gymId = gym2._id;
  user2 = await userRepo.create(
    testUser2.cognitoId,
    testUser2.email,
    testUser2.gymId!,
    testUser2.firstName,
    testUser2.lastName
  );
  const myGym2 = await gymRepo.get(user2.cognitoId);
  expect(myGym2).toBeDefined();
  expect(myGym2._id).toEqual(gym2._id);
  expect(myGym2.name).toBe(gymName2);
  compareAddress(myGym2.address, gymAddress2);
  compareLocation(myGym2.location, gymLocation2);
});

test("Get the nearest gyms", async () => {
  let nearestGyms = await gymRepo.getNearest(
    { type: "Point", coordinates: [50.1, 40.1] },
    10000
  );
  expect(nearestGyms).toBeDefined();
  expect(nearestGyms.length).toBe(0);
  nearestGyms = await gymRepo.getNearest(
    { type: "Point", coordinates: [50.1, 40.1] },
    200000
  );
  expect(nearestGyms.length).toBe(1);
  expect(nearestGyms[0]._id).toEqual(gym1._id);
  expect(nearestGyms[0].name).toBe(gymName1);
  compareAddress(nearestGyms[0].address, gymAddress1);
  compareLocation(nearestGyms[0].location, gymLocation1);
  nearestGyms = await gymRepo.getNearest(
    { type: "Point", coordinates: [50.1, 40.1] },
    9000000
  );
  expect(nearestGyms.length).toBe(2);
  expect(nearestGyms[0]._id).toEqual(gym1._id);
  expect(nearestGyms[0].name).toBe(gymName1);
  compareAddress(nearestGyms[0].address, gymAddress1);
  compareLocation(nearestGyms[0].location, gymLocation1);
  expect(nearestGyms[1]._id).toEqual(gym2._id);
  expect(nearestGyms[1].name).toBe(gymName2);
  compareAddress(nearestGyms[1].address, gymAddress2);
  compareLocation(nearestGyms[1].location, gymLocation2);
  nearestGyms = await gymRepo.getNearest(
    { type: "Point", coordinates: [50.1, 40.1] },
    9000000,
    1
  );
  expect(nearestGyms.length).toBe(1);
  expect(nearestGyms[0]._id).toEqual(gym1._id);
  expect(nearestGyms[0].name).toBe(gymName1);
  compareAddress(nearestGyms[0].address, gymAddress1);
  compareLocation(nearestGyms[0].location, gymLocation1);
});
