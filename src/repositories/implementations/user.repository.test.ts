import {
  compareExploreUserData,
  compareUserData,
} from "../../../test/helpers/comparisons";
import { dependencies, Repositories } from "../../common/dependency-injection";
import { IGymEntity, IUserEntity } from "../../entities";
import {
  IGymRepository,
  IRelationshipRepository,
  IUserRepository,
} from "../interfaces";

const testGym1 = {
  name: "testGym1",
  address: {
    street: "testStreet1",
    city: "testCity1",
    state: "testState1",
    zipCode: "testZipCode1",
  },
  location: {
    type: "Point",
    coordinates: [-122.4194, 37.7749] as [number, number],
  },
};

const testGym2 = {
  name: "testGym2",
  address: {
    street: "testStreet2",
    city: "testCity2",
    state: "testState2",
    zipCode: "testZipCode2",
  },
  location: {
    type: "Point",
    coordinates: [122.4194, 37.7749] as [number, number],
  },
};

const testUser1 = {
  cognitoId: "testUser1",
  gymId: undefined as string | undefined,
  firstName: "testUser1",
  lastName: "testUser1",
  email: "testEmail1@gmail.com",
};

const testUser2 = {
  cognitoId: "testUser2",
  gymId: undefined as string | undefined,
  firstName: "testUser2",
  lastName: "testUser2",
  email: "testEmail2@gmail.com",
};

const testUser3 = {
  cognitoId: "testUser3",
  gymId: undefined as string | undefined,
  firstName: "testUser3",
  lastName: "testUser3",
  email: "testEmail3@gmail.com",
};

const testUser4 = {
  cognitoId: "testUser4",
  gymId: undefined as string | undefined,
  firstName: "testUser4",
  lastName: "testUser4",
  email: "testEmail4@gmail.com",
};

let gym1: IGymEntity;
let gym2: IGymEntity;
let user1: IUserEntity;
let user2: IUserEntity;
let user3: IUserEntity;
let user4: IUserEntity;

let userRepo: IUserRepository;
let gymRepo: IGymRepository;
let relationshipRepo: IRelationshipRepository;

beforeAll(async () => {
  userRepo = dependencies.get(Repositories.user);
  gymRepo = dependencies.get(Repositories.gym);
  relationshipRepo = dependencies.get(Repositories.relationship);
  gym1 = await gymRepo.create(
    testGym1.name,
    testGym1.address,
    testGym1.location
  );
  gym2 = await gymRepo.create(
    testGym2.name,
    testGym2.address,
    testGym2.location
  );
  testUser1.gymId = gym1._id;
  testUser2.gymId = gym1._id;
  testUser3.gymId = gym1._id;
  testUser4.gymId = gym2._id;
});

test("Users can be created", async () => {
  user1 = await userRepo.create(
    testUser1.cognitoId,
    testUser1.email,
    testUser1.gymId!,
    testUser1.firstName,
    testUser1.lastName
  );
  compareUserData(user1, testUser1);
  user2 = await userRepo.create(
    testUser2.cognitoId,
    testUser2.email,
    testUser2.gymId!,
    testUser2.firstName,
    testUser2.lastName
  );
  compareUserData(user2, testUser2);
  user3 = await userRepo.create(
    testUser3.cognitoId,
    testUser3.email,
    testUser3.gymId!,
    testUser3.firstName,
    testUser3.lastName
  );
  compareUserData(user3, testUser3);
  user4 = await userRepo.create(
    testUser4.cognitoId,
    testUser4.email,
    testUser4.gymId!,
    testUser4.firstName,
    testUser4.lastName
  );
  compareUserData(user4, testUser4);
});

test("Users can be explored properly", async () => {
  let exploreResults = await userRepo.exploreUsers(user1.cognitoId);
  expect(exploreResults.length).toEqual(2);
  let foundUser2 = false;
  let foundUser3 = false;
  exploreResults.forEach((user) => {
    if (user.cognitoId == user2.cognitoId && !foundUser2) {
      expect(user.firstName).toEqual(user2.firstName);
      expect(user.lastName).toEqual(user2.lastName);
      foundUser2 = true;
    } else if (user.cognitoId == user3.cognitoId && !foundUser3) {
      expect(user.firstName).toEqual(user3.firstName);
      expect(user.lastName).toEqual(user3.lastName);
      foundUser3 = true;
    } else {
      expect(false).toBeTruthy();
    }
  });
  exploreResults = await userRepo.exploreUsers(user1.cognitoId, 1, 1);
  expect(exploreResults.length).toEqual(1);
  foundUser2 = false;
  foundUser3 = false;
  exploreResults.forEach((user) => {
    if (user.cognitoId == user2.cognitoId && !foundUser2) {
      expect(user.firstName).toEqual(user2.firstName);
      expect(user.lastName).toEqual(user2.lastName);
      foundUser2 = true;
    } else if (user.cognitoId == user3.cognitoId && !foundUser3) {
      expect(user.firstName).toEqual(user3.firstName);
      expect(user.lastName).toEqual(user3.lastName);
      foundUser3 = true;
    } else {
      expect(false).toBeTruthy();
    }
  });
  exploreResults = await userRepo.exploreUsers(user1.cognitoId, 2, 1);
  expect(exploreResults.length).toEqual(0);
  await relationshipRepo.createRequest(user1.cognitoId, user2.cognitoId);
  exploreResults = await userRepo.exploreUsers(user1.cognitoId);
  expect(exploreResults.length).toEqual(1);
  compareExploreUserData(exploreResults[0], user3);
  await relationshipRepo.createRequest(user3.cognitoId, user1.cognitoId);
  exploreResults = await userRepo.exploreUsers(user1.cognitoId);
  expect(exploreResults.length).toEqual(1);
  compareExploreUserData(exploreResults[0], user3);
  await relationshipRepo.createDeny(user3.cognitoId, user1.cognitoId);
  exploreResults = await userRepo.exploreUsers(user1.cognitoId);
  expect(exploreResults.length).toEqual(1);
  compareExploreUserData(exploreResults[0], user3);
  await relationshipRepo.createBlock(user3.cognitoId, user1.cognitoId);
  exploreResults = await userRepo.exploreUsers(user1.cognitoId);
  expect(exploreResults.length).toEqual(0);
  await relationshipRepo.createRequest(user3.cognitoId, user1.cognitoId);
  exploreResults = await userRepo.exploreUsers(user1.cognitoId);
  expect(exploreResults.length).toEqual(1);
  compareExploreUserData(exploreResults[0], user3);
  await relationshipRepo.createDeny(user1.cognitoId, user3.cognitoId);
  exploreResults = await userRepo.exploreUsers(user1.cognitoId);
  expect(exploreResults.length).toEqual(0);
  await relationshipRepo.createBlock(user1.cognitoId, user3.cognitoId);
  expect(exploreResults.length).toEqual(0);
});

test("Users can be deleted properly", async () => {
  await userRepo.delete(user1.cognitoId);
  await userRepo.delete(user2.cognitoId);
  expect(await userRepo.get(user1.cognitoId)).toBeNull();
  expect(await userRepo.get(user2.cognitoId)).toBeNull();
  expect(await userRepo.get(user3.cognitoId)).not.toBeNull();
  await userRepo.delete(user3.cognitoId);
  expect(await userRepo.get(user3.cognitoId)).toBeNull();
});
