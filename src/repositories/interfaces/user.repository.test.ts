import { fail } from "assert";
import { compareUsers } from "../../../test/helpers/comparisons";
import { kUserNotFound } from "../../common/failures";
import { gymRepository, userRepository } from "../injection";

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
    coordinates: [-75.99618967933559, 36.8497312] as [number, number],
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
    coordinates: [-80.4138162, 37.2294115] as [number, number],
  },
};

const testUser1 = {
  cognitoId: "testCognitoId1",
  firstName: "firstName1",
  lastName: "lastName1",
  email: "email1@abc.com",
};

const testUser2 = {
  cognitoId: "testCognitoId2",
  firstName: "firstName2",
  lastName: "lastName2",
  email: "email2@abc.com",
};

const testUser3 = {
  cognitoId: "testCognitoId3",
  firstName: "firstName3",
  lastName: "lastName3",
  email: "email3@abc.com",
};

afterEach(async () => {
  const gymRepo = gymRepository();
  const userRepo = userRepository();
  await gymRepo.deleteAll();
  await userRepo.deleteAll();
});

test("Create user", async () => {
  const gymRepo = gymRepository();
  const userRepo = userRepository();
  const gym1 = await gymRepo.create(testGym1);
  const gym2 = await gymRepo.create(testGym2);
  const user1 = await userRepo.create({
    ...testUser1,
    gymId: gym1._id,
  });
  const user2 = await userRepo.create({
    ...testUser2,
    gymId: gym2._id,
  });
  compareUsers(user1, {
    ...testUser1,
    gymId: gym1._id,
    _id: user1._id,
    confirmed: false,
  });
  compareUsers(user2, {
    ...testUser2,
    gymId: gym2._id,
    _id: user2._id,
    confirmed: false,
  });
});

test("Delete user", async () => {
  const gymRepo = gymRepository();
  const userRepo = userRepository();
  const gym1 = await gymRepo.create(testGym1);
  const user1 = await userRepo.create({
    ...testUser1,
    gymId: gym1._id,
  });
  const user2 = await userRepo.create({
    ...testUser2,
    gymId: gym1._id,
  });
  expect(await userRepo.delete(user1.cognitoId)).toBeUndefined();
  let user = await userRepo.get(user1.cognitoId);
  user.tap({
    left: (user) => {
      fail(`Expected failure, but got ${user}`);
    },
    right: (failure) => {
      expect(failure).toBe(kUserNotFound);
    },
  });
  expect(await userRepo.delete(user2.cognitoId)).toBeUndefined();
  user = await userRepo.get(user2.cognitoId);
  user.tap({
    left: (user) => {
      fail(`Expected failure, but got ${user}`);
    },
    right: (failure) => {
      expect(failure).toBe(kUserNotFound);
    },
  });
  expect(await userRepo.delete(user1.cognitoId)).toBe(kUserNotFound);
});

test("Get user by email", async () => {
  const gymRepo = gymRepository();
  const userRepo = userRepository();
  const gym1 = await gymRepo.create(testGym1);
  const user1 = await userRepo.create({
    ...testUser1,
    gymId: gym1._id,
  });
  const user2 = await userRepo.create({
    ...testUser2,
    gymId: gym1._id,
  });
  const user3 = await userRepo.create({
    ...testUser3,
    gymId: gym1._id,
  });
  let user = await userRepo.getByEmail(testUser1.email);
  user.tap({
    left: (user) => {
      compareUsers(user, user1);
    },
    right: (failure) => {
      fail(`Expected user, but got ${failure}`);
    },
  });
  user = await userRepo.getByEmail(testUser2.email);
  user.tap({
    left: (user) => {
      compareUsers(user, user2);
    },
    right: (failure) => {
      fail(`Expected user, but got ${failure}`);
    },
  });
  user = await userRepo.getByEmail(testUser3.email);
  user.tap({
    left: (user) => {
      compareUsers(user, user3);
    },
    right: (failure) => {
      fail(`Expected user, but got ${failure}`);
    },
  });
  user = await userRepo.getByEmail("fakeEmail");
  user.tap({
    left: (user) => {
      fail(`Expected failure, but got ${user}`);
    },
    right: (failure) => {
      expect(failure).toBe(kUserNotFound);
    },
  });
});

test("Get user by cognito id", async () => {
  const gymRepo = gymRepository();
  const userRepo = userRepository();
  const gym1 = await gymRepo.create(testGym1);
  const user1 = await userRepo.create({
    ...testUser1,
    gymId: gym1._id,
  });
  const user2 = await userRepo.create({
    ...testUser2,
    gymId: gym1._id,
  });
  const user3 = await userRepo.create({
    ...testUser3,
    gymId: gym1._id,
  });
  let user = await userRepo.get(testUser1.cognitoId);
  user.tap({
    left: (user) => {
      compareUsers(user, user1);
    },
    right: (failure) => {
      fail(`Expected user, but got ${failure}`);
    },
  });
  user = await userRepo.get(testUser2.cognitoId);
  user.tap({
    left: (user) => {
      compareUsers(user, user2);
    },
    right: (failure) => {
      fail(`Expected user, but got ${failure}`);
    },
  });
  user = await userRepo.get(testUser3.cognitoId);
  user.tap({
    left: (user) => {
      compareUsers(user, user3);
    },
    right: (failure) => {
      fail(`Expected user, but got ${failure}`);
    },
  });
  user = await userRepo.get("fakeCognitoId");
  user.tap({
    left: (user) => {
      fail(`Expected failure, but got ${user}`);
    },
    right: (failure) => {
      expect(failure).toBe(kUserNotFound);
    },
  });
});

test("Set confirmed", async () => {
  const gymRepo = gymRepository();
  const userRepo = userRepository();
  const gym1 = await gymRepo.create(testGym1);
  const user1 = await userRepo.create({
    ...testUser1,
    gymId: gym1._id,
  });
  const user2 = await userRepo.create({
    ...testUser2,
    gymId: gym1._id,
  });
  const user3 = await userRepo.create({
    ...testUser3,
    gymId: gym1._id,
  });
  expect(user1.confirmed).toBeFalsy();
  expect(user2.confirmed).toBeFalsy();
  expect(user3.confirmed).toBeFalsy();
  expect(await userRepo.setConfirmed(testUser1.cognitoId)).toBeUndefined();
  let user = await userRepo.get(testUser1.cognitoId);
  user.tap({
    left: (user) => {
      expect(user.confirmed).toBeTruthy();
    },
    right: (failure) => {
      fail(`Expected user, but got ${failure}`);
    },
  });
  expect(await userRepo.setConfirmed(testUser2.cognitoId)).toBeUndefined();
  user = await userRepo.get(testUser2.cognitoId);
  user.tap({
    left: (user) => {
      expect(user.confirmed).toBeTruthy();
    },
    right: (failure) => {
      fail(`Expected user, but got ${failure}`);
    },
  });
  expect(await userRepo.setConfirmed(testUser3.cognitoId)).toBeUndefined();
  user = await userRepo.get(testUser3.cognitoId);
  user.tap({
    left: (user) => {
      expect(user.confirmed).toBeTruthy();
    },
    right: (failure) => {
      fail(`Expected user, but got ${failure}`);
    },
  });
  expect(await userRepo.setConfirmed("fakeCognitoId")).toBe(kUserNotFound);
});

test("Have same gym", async () => {
  const gymRepo = gymRepository();
  const userRepo = userRepository();
  const gym1 = await gymRepo.create(testGym1);
  const gym2 = await gymRepo.create(testGym2);
  const user1 = await userRepo.create({
    ...testUser1,
    gymId: gym1._id,
  });
  const user2 = await userRepo.create({
    ...testUser2,
    gymId: gym1._id,
  });
  const user3 = await userRepo.create({
    ...testUser3,
    gymId: gym2._id,
  });
  expect(
    await userRepo.haveSameGym(user1.cognitoId, user2.cognitoId)
  ).toBeTruthy();
  expect(
    await userRepo.haveSameGym(user2.cognitoId, user1.cognitoId)
  ).toBeTruthy();
  expect(
    await userRepo.haveSameGym(user1.cognitoId, user3.cognitoId)
  ).toBeFalsy();
  expect(
    await userRepo.haveSameGym(user3.cognitoId, user1.cognitoId)
  ).toBeFalsy();
  expect(
    await userRepo.haveSameGym(user2.cognitoId, user3.cognitoId)
  ).toBeFalsy();
  expect(
    await userRepo.haveSameGym(user3.cognitoId, user2.cognitoId)
  ).toBeFalsy();
  expect(
    await userRepo.haveSameGym("fakeCognitoId", user3.cognitoId)
  ).toBeFalsy();
  expect(
    await userRepo.haveSameGym(user1.cognitoId, "fakeCognitoId")
  ).toBeFalsy();
});
