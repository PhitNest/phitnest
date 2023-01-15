import {
  comparePublicUsers,
  compareUsers,
} from "../../../../test/helpers/comparisons";
import { kUserNotFound } from "../../../common/failures";
import { IUserEntity } from "../../../domain/entities";
import dataSources from "../injection";

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
  const { gymDatabase, userDatabase } = dataSources();
  await gymDatabase.deleteAll();
  await userDatabase.deleteAll();
});

test("Create user", async () => {
  const { gymDatabase, userDatabase } = dataSources();
  const gym1 = await gymDatabase.create(testGym1);
  const gym2 = await gymDatabase.create(testGym2);
  const user1 = await userDatabase.create({
    ...testUser1,
    gymId: gym1._id,
  });
  const user2 = await userDatabase.create({
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
  const { gymDatabase, userDatabase } = dataSources();
  const gym1 = await gymDatabase.create(testGym1);
  const user1 = await userDatabase.create({
    ...testUser1,
    gymId: gym1._id,
  });
  const user2 = await userDatabase.create({
    ...testUser2,
    gymId: gym1._id,
  });
  expect(await userDatabase.delete(user1.cognitoId)).toBeUndefined();
  let failure = await userDatabase.get(user1.cognitoId);
  expect(failure).toBe(kUserNotFound);
  expect(await userDatabase.delete(user2.cognitoId)).toBeUndefined();
  failure = await userDatabase.get(user2.cognitoId);
  expect(failure).toBe(kUserNotFound);
  expect(await userDatabase.delete(user1.cognitoId)).toBe(kUserNotFound);
});

test("Get user by email", async () => {
  const { gymDatabase, userDatabase } = dataSources();
  const gym1 = await gymDatabase.create(testGym1);
  const user1 = await userDatabase.create({
    ...testUser1,
    gymId: gym1._id,
  });
  const user2 = await userDatabase.create({
    ...testUser2,
    gymId: gym1._id,
  });
  const user3 = await userDatabase.create({
    ...testUser3,
    gymId: gym1._id,
  });
  let user = (await userDatabase.getByEmail(testUser1.email)) as IUserEntity;
  compareUsers(user, user1);
  user = (await userDatabase.getByEmail(testUser2.email)) as IUserEntity;
  compareUsers(user, user2);
  user = (await userDatabase.getByEmail(testUser3.email)) as IUserEntity;
  compareUsers(user, user3);
  expect(await userDatabase.getByEmail("fakeEmail")).toBe(kUserNotFound);
});

test("Get users by gym", async () => {
  const { gymDatabase, userDatabase } = dataSources();
  const gym1 = await gymDatabase.create(testGym1);
  const gym2 = await gymDatabase.create(testGym2);
  const user1 = await userDatabase.create({
    ...testUser1,
    gymId: gym1._id,
  });
  const user2 = await userDatabase.create({
    ...testUser2,
    gymId: gym1._id,
  });
  const user3 = await userDatabase.create({
    ...testUser3,
    gymId: gym2._id,
  });
  let users = await userDatabase.getByGym(gym1._id);
  expect(users.length).toBe(2);
  comparePublicUsers(users[0], user1);
  comparePublicUsers(users[1], user2);
  users = await userDatabase.getByGym(gym2._id);
  expect(users.length).toBe(1);
  comparePublicUsers(users[0], user3);
});

test("Get user by cognito id", async () => {
  const { gymDatabase, userDatabase } = dataSources();
  const gym1 = await gymDatabase.create(testGym1);
  const user1 = await userDatabase.create({
    ...testUser1,
    gymId: gym1._id,
  });
  const user2 = await userDatabase.create({
    ...testUser2,
    gymId: gym1._id,
  });
  const user3 = await userDatabase.create({
    ...testUser3,
    gymId: gym1._id,
  });
  let user = (await userDatabase.get(testUser1.cognitoId)) as IUserEntity;
  compareUsers(user, user1);
  user = (await userDatabase.get(testUser2.cognitoId)) as IUserEntity;
  compareUsers(user, user2);
  user = (await userDatabase.get(testUser3.cognitoId)) as IUserEntity;
  compareUsers(user, user3);
  expect(await userDatabase.get("fakeCognitoId")).toBe(kUserNotFound);
});

test("Set confirmed", async () => {
  const { gymDatabase, userDatabase } = dataSources();
  const gym1 = await gymDatabase.create(testGym1);
  const user1 = await userDatabase.create({
    ...testUser1,
    gymId: gym1._id,
  });
  const user2 = await userDatabase.create({
    ...testUser2,
    gymId: gym1._id,
  });
  const user3 = await userDatabase.create({
    ...testUser3,
    gymId: gym1._id,
  });
  expect(user1.confirmed).toBeFalsy();
  expect(user2.confirmed).toBeFalsy();
  expect(user3.confirmed).toBeFalsy();
  expect(await userDatabase.setConfirmed(testUser1.cognitoId)).toBeUndefined();
  let user = (await userDatabase.get(testUser1.cognitoId)) as IUserEntity;
  expect(user.confirmed).toBeTruthy();
  expect(await userDatabase.setConfirmed(testUser2.cognitoId)).toBeUndefined();
  user = (await userDatabase.get(testUser2.cognitoId)) as IUserEntity;
  expect(user.confirmed).toBeTruthy();
  expect(await userDatabase.setConfirmed(testUser3.cognitoId)).toBeUndefined();
  user = (await userDatabase.get(testUser3.cognitoId)) as IUserEntity;
  expect(user.confirmed).toBeTruthy();
  expect(await userDatabase.setConfirmed("fakeCognitoId")).toBe(kUserNotFound);
});

test("Have same gym", async () => {
  const { gymDatabase, userDatabase } = dataSources();
  const gym1 = await gymDatabase.create(testGym1);
  const gym2 = await gymDatabase.create(testGym2);
  const user1 = await userDatabase.create({
    ...testUser1,
    gymId: gym1._id,
  });
  const user2 = await userDatabase.create({
    ...testUser2,
    gymId: gym1._id,
  });
  const user3 = await userDatabase.create({
    ...testUser3,
    gymId: gym2._id,
  });
  expect(
    await userDatabase.haveSameGym(user1.cognitoId, user2.cognitoId)
  ).toBeTruthy();
  expect(
    await userDatabase.haveSameGym(user2.cognitoId, user1.cognitoId)
  ).toBeTruthy();
  expect(
    await userDatabase.haveSameGym(user1.cognitoId, user3.cognitoId)
  ).toBeFalsy();
  expect(
    await userDatabase.haveSameGym(user3.cognitoId, user1.cognitoId)
  ).toBeFalsy();
  expect(
    await userDatabase.haveSameGym(user2.cognitoId, user3.cognitoId)
  ).toBeFalsy();
  expect(
    await userDatabase.haveSameGym(user3.cognitoId, user2.cognitoId)
  ).toBeFalsy();
  expect(
    await userDatabase.haveSameGym("fakeCognitoId", user3.cognitoId)
  ).toBeFalsy();
  expect(
    await userDatabase.haveSameGym(user1.cognitoId, "fakeCognitoId")
  ).toBeFalsy();
});
