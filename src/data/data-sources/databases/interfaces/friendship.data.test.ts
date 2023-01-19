import { compareFriendships } from "../../../../../test/helpers/comparisons";
import { kFriendshipNotFound } from "../../../../common/failures";
import { IFriendshipEntity } from "../../../../domain/entities";
import dataSources from "../../injection";

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

const testUser4 = {
  cognitoId: "testCognitoId4",
  firstName: "firstName4",
  lastName: "lastName4",
  email: "email4@abc.com",
};

const testFriendship1 = [testUser1.cognitoId, testUser2.cognitoId] as [
  string,
  string
];

const testFriendship2 = [testUser1.cognitoId, testUser3.cognitoId] as [
  string,
  string
];

const testFriendship3 = [testUser2.cognitoId, testUser3.cognitoId] as [
  string,
  string
];

const testFriendship4 = [testUser1.cognitoId, testUser4.cognitoId] as [
  string,
  string
];

afterEach(async () => {
  const { gymDatabase, userDatabase, friendshipDatabase } = dataSources();
  await gymDatabase.deleteAll();
  await userDatabase.deleteAll();
  await friendshipDatabase.deleteAll();
});

test("Create friendship", async () => {
  const { gymDatabase, userDatabase, friendshipDatabase } = dataSources();
  const gym = await gymDatabase.create(testGym1);
  await userDatabase.create({ ...testUser1, gymId: gym._id });
  await userDatabase.create({ ...testUser2, gymId: gym._id });
  let friendship = await friendshipDatabase.create(testFriendship1);
  expect(friendship.userCognitoIds).toEqual(testFriendship1);
  friendship = await friendshipDatabase.create(testFriendship2);
  expect(friendship.userCognitoIds).toEqual(testFriendship2);
  friendship = await friendshipDatabase.create(testFriendship3);
  expect(friendship.userCognitoIds).toEqual(testFriendship3);
  friendship = await friendshipDatabase.create(testFriendship4);
  expect(friendship.userCognitoIds).toEqual(testFriendship4);
});

test("Create friendship with unsorted cognito IDs", async () => {
  const { gymDatabase, userDatabase, friendshipDatabase } = dataSources();
  const gym = await gymDatabase.create(testGym1);
  await userDatabase.create({ ...testUser1, gymId: gym._id });
  await userDatabase.create({ ...testUser2, gymId: gym._id });
  const friendship = await friendshipDatabase.create([
    testUser2.cognitoId,
    testUser1.cognitoId,
  ]);
  expect(friendship.userCognitoIds).toEqual(testFriendship1);
  const result = (await friendshipDatabase.getByUsers([
    testUser2.cognitoId,
    testUser1.cognitoId,
  ])) as IFriendshipEntity;
  compareFriendships(result, friendship);
});

test("Get friends by cognito ID", async () => {
  const { gymDatabase, userDatabase, friendshipDatabase } = dataSources();
  const gym = await gymDatabase.create(testGym1);
  await userDatabase.create({ ...testUser1, gymId: gym._id });
  await userDatabase.create({ ...testUser2, gymId: gym._id });
  await userDatabase.create({ ...testUser3, gymId: gym._id });
  const friendship1 = await friendshipDatabase.create(testFriendship1);
  let friendships = await friendshipDatabase.get(testUser1.cognitoId);
  expect(friendships.length).toEqual(1);
  compareFriendships(friendships[0], friendship1);
  friendships = await friendshipDatabase.get(testUser2.cognitoId);
  expect(friendships.length).toEqual(1);
  compareFriendships(friendships[0], friendship1);
  friendships = await friendshipDatabase.get(testUser3.cognitoId);
  expect(friendships.length).toEqual(0);
  friendships = await friendshipDatabase.get(testUser4.cognitoId);
  expect(friendships.length).toEqual(0);
  const friendship2 = await friendshipDatabase.create(testFriendship2);
  friendships = await friendshipDatabase.get(testUser1.cognitoId);
  expect(friendships.length).toEqual(2);
  compareFriendships(friendships[0], friendship2);
  compareFriendships(friendships[1], friendship1);
  friendships = await friendshipDatabase.get(testUser2.cognitoId);
  expect(friendships.length).toEqual(1);
  compareFriendships(friendships[0], friendship1);
  friendships = await friendshipDatabase.get(testUser3.cognitoId);
  expect(friendships.length).toEqual(1);
  compareFriendships(friendships[0], friendship2);
  friendships = await friendshipDatabase.get(testUser4.cognitoId);
  expect(friendships.length).toEqual(0);
  const friendship3 = await friendshipDatabase.create(testFriendship3);
  friendships = await friendshipDatabase.get(testUser1.cognitoId);
  expect(friendships.length).toEqual(2);
  compareFriendships(friendships[0], friendship2);
  compareFriendships(friendships[1], friendship1);
  friendships = await friendshipDatabase.get(testUser2.cognitoId);
  expect(friendships.length).toEqual(2);
  compareFriendships(friendships[0], friendship3);
  compareFriendships(friendships[1], friendship1);
  friendships = await friendshipDatabase.get(testUser3.cognitoId);
  expect(friendships.length).toEqual(2);
  compareFriendships(friendships[0], friendship3);
  compareFriendships(friendships[1], friendship2);
  friendships = await friendshipDatabase.get(testUser4.cognitoId);
  expect(friendships.length).toEqual(0);
  const friendship4 = await friendshipDatabase.create(testFriendship4);
  friendships = await friendshipDatabase.get(testUser1.cognitoId);
  expect(friendships.length).toEqual(3);
  compareFriendships(friendships[0], friendship4);
  compareFriendships(friendships[1], friendship2);
  compareFriendships(friendships[2], friendship1);
  friendships = await friendshipDatabase.get(testUser2.cognitoId);
  expect(friendships.length).toEqual(2);
  compareFriendships(friendships[0], friendship3);
  compareFriendships(friendships[1], friendship1);
  friendships = await friendshipDatabase.get(testUser3.cognitoId);
  expect(friendships.length).toEqual(2);
  compareFriendships(friendships[0], friendship3);
  compareFriendships(friendships[1], friendship2);
  friendships = await friendshipDatabase.get(testUser4.cognitoId);
  expect(friendships.length).toEqual(1);
  compareFriendships(friendships[0], friendship4);
});

test("Get friendship by cognito IDs", async () => {
  const { gymDatabase, userDatabase, friendshipDatabase } = dataSources();
  const gym = await gymDatabase.create(testGym1);
  await userDatabase.create({ ...testUser1, gymId: gym._id });
  await userDatabase.create({ ...testUser2, gymId: gym._id });
  await userDatabase.create({ ...testUser3, gymId: gym._id });
  const friendship1 = await friendshipDatabase.create(testFriendship1);
  let result = (await friendshipDatabase.getByUsers(
    testFriendship1
  )) as IFriendshipEntity;
  compareFriendships(result, friendship1);
  const friendship2 = await friendshipDatabase.create(testFriendship2);
  result = (await friendshipDatabase.getByUsers(
    testFriendship2
  )) as IFriendshipEntity;
  compareFriendships(result, friendship2);
  const friendship3 = await friendshipDatabase.create(testFriendship3);
  result = (await friendshipDatabase.getByUsers(
    testFriendship3
  )) as IFriendshipEntity;
  compareFriendships(result, friendship3);
  const friendship4 = await friendshipDatabase.create(testFriendship4);
  result = (await friendshipDatabase.getByUsers(
    testFriendship4
  )) as IFriendshipEntity;
  compareFriendships(result, friendship4);
  expect(await friendshipDatabase.getByUsers(["fakeId", "fakeId2"])).toBe(
    kFriendshipNotFound
  );
  expect(
    await friendshipDatabase.getByUsers(["fakeId", testUser1.cognitoId])
  ).toBe(kFriendshipNotFound);
  expect(
    await friendshipDatabase.getByUsers([testUser1.cognitoId, "fakeId"])
  ).toBe(kFriendshipNotFound);
});

test("Delete friendships", async () => {
  const { gymDatabase, userDatabase, friendshipDatabase } = dataSources();
  const gym = await gymDatabase.create(testGym1);
  await userDatabase.create({ ...testUser1, gymId: gym._id });
  await userDatabase.create({ ...testUser2, gymId: gym._id });
  await userDatabase.create({ ...testUser3, gymId: gym._id });
  await friendshipDatabase.create(testFriendship1);
  await friendshipDatabase.create(testFriendship2);
  await friendshipDatabase.create(testFriendship3);
  await friendshipDatabase.create(testFriendship4);
  expect(await friendshipDatabase.delete(testFriendship1)).toBeUndefined();
  expect(await friendshipDatabase.getByUsers(testFriendship1)).toBe(
    kFriendshipNotFound
  );
  expect(await friendshipDatabase.delete(testFriendship2)).toBeUndefined();
  expect(await friendshipDatabase.getByUsers(testFriendship2)).toBe(
    kFriendshipNotFound
  );
  expect(await friendshipDatabase.delete(testFriendship3)).toBeUndefined();
  expect(await friendshipDatabase.getByUsers(testFriendship3)).toBe(
    kFriendshipNotFound
  );
  expect(await friendshipDatabase.delete(testFriendship4)).toBeUndefined();
  expect(await friendshipDatabase.getByUsers(testFriendship4)).toBe(
    kFriendshipNotFound
  );
  expect(await friendshipDatabase.delete(["fakeId", "fakeId2"])).toBe(
    kFriendshipNotFound
  );
});