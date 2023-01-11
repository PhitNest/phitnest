import { fail } from "assert";
import { compareFriendships } from "../../../test/helpers/comparisons";
import { kFriendshipNotFound } from "../../common/failures";
import {
  friendshipRepository,
  gymRepository,
  userRepository,
} from "../injection";

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
  const gymRepo = gymRepository();
  const userRepo = userRepository();
  const friendshipRepo = friendshipRepository();
  await gymRepo.deleteAll();
  await userRepo.deleteAll();
  await friendshipRepo.deleteAll();
});

test("Create friendship", async () => {
  const gymRepo = gymRepository();
  const userRepo = userRepository();
  const friendshipRepo = friendshipRepository();
  const gym = await gymRepo.create(testGym1);
  const user1 = await userRepo.create({ ...testUser1, gymId: gym._id });
  const user2 = await userRepo.create({ ...testUser2, gymId: gym._id });
  let friendship = await friendshipRepo.create(testFriendship1);
  expect(friendship.userCognitoIds).toEqual(testFriendship1);
  friendship = await friendshipRepo.create(testFriendship2);
  expect(friendship.userCognitoIds).toEqual(testFriendship2);
  friendship = await friendshipRepo.create(testFriendship3);
  expect(friendship.userCognitoIds).toEqual(testFriendship3);
  friendship = await friendshipRepo.create(testFriendship4);
  expect(friendship.userCognitoIds).toEqual(testFriendship4);
});

test("Create friendship with unsorted cognito IDs", async () => {
  const gymRepo = gymRepository();
  const userRepo = userRepository();
  const friendshipRepo = friendshipRepository();
  const gym = await gymRepo.create(testGym1);
  const user1 = await userRepo.create({ ...testUser1, gymId: gym._id });
  const user2 = await userRepo.create({ ...testUser2, gymId: gym._id });
  const friendship = await friendshipRepo.create([
    testUser2.cognitoId,
    testUser1.cognitoId,
  ]);
  expect(friendship.userCognitoIds).toEqual(testFriendship1);
  const result = await friendshipRepo.getByUsers([
    testUser2.cognitoId,
    testUser1.cognitoId,
  ]);
  result.tap({
    left: (friendship) => {
      compareFriendships(friendship, friendship);
    },
    right: (failure) => {
      fail(`Expected to find friendship, but got ${failure}`);
    },
  });
});

test("Get friends by cognito ID", async () => {
  const gymRepo = gymRepository();
  const userRepo = userRepository();
  const friendshipRepo = friendshipRepository();
  const gym = await gymRepo.create(testGym1);
  const user1 = await userRepo.create({ ...testUser1, gymId: gym._id });
  const user2 = await userRepo.create({ ...testUser2, gymId: gym._id });
  const user3 = await userRepo.create({ ...testUser3, gymId: gym._id });
  const friendship1 = await friendshipRepo.create(testFriendship1);
  let friendships = await friendshipRepo.get(testUser1.cognitoId);
  expect(friendships.length).toEqual(1);
  compareFriendships(friendships[0], friendship1);
  friendships = await friendshipRepo.get(testUser2.cognitoId);
  expect(friendships.length).toEqual(1);
  compareFriendships(friendships[0], friendship1);
  friendships = await friendshipRepo.get(testUser3.cognitoId);
  expect(friendships.length).toEqual(0);
  friendships = await friendshipRepo.get(testUser4.cognitoId);
  expect(friendships.length).toEqual(0);
  const friendship2 = await friendshipRepo.create(testFriendship2);
  friendships = await friendshipRepo.get(testUser1.cognitoId);
  expect(friendships.length).toEqual(2);
  compareFriendships(friendships[0], friendship2);
  compareFriendships(friendships[1], friendship1);
  friendships = await friendshipRepo.get(testUser2.cognitoId);
  expect(friendships.length).toEqual(1);
  compareFriendships(friendships[0], friendship1);
  friendships = await friendshipRepo.get(testUser3.cognitoId);
  expect(friendships.length).toEqual(1);
  compareFriendships(friendships[0], friendship2);
  friendships = await friendshipRepo.get(testUser4.cognitoId);
  expect(friendships.length).toEqual(0);
  const friendship3 = await friendshipRepo.create(testFriendship3);
  friendships = await friendshipRepo.get(testUser1.cognitoId);
  expect(friendships.length).toEqual(2);
  compareFriendships(friendships[0], friendship2);
  compareFriendships(friendships[1], friendship1);
  friendships = await friendshipRepo.get(testUser2.cognitoId);
  expect(friendships.length).toEqual(2);
  compareFriendships(friendships[0], friendship3);
  compareFriendships(friendships[1], friendship1);
  friendships = await friendshipRepo.get(testUser3.cognitoId);
  expect(friendships.length).toEqual(2);
  compareFriendships(friendships[0], friendship3);
  compareFriendships(friendships[1], friendship2);
  friendships = await friendshipRepo.get(testUser4.cognitoId);
  expect(friendships.length).toEqual(0);
  const friendship4 = await friendshipRepo.create(testFriendship4);
  friendships = await friendshipRepo.get(testUser1.cognitoId);
  expect(friendships.length).toEqual(3);
  compareFriendships(friendships[0], friendship4);
  compareFriendships(friendships[1], friendship2);
  compareFriendships(friendships[2], friendship1);
  friendships = await friendshipRepo.get(testUser2.cognitoId);
  expect(friendships.length).toEqual(2);
  compareFriendships(friendships[0], friendship3);
  compareFriendships(friendships[1], friendship1);
  friendships = await friendshipRepo.get(testUser3.cognitoId);
  expect(friendships.length).toEqual(2);
  compareFriendships(friendships[0], friendship3);
  compareFriendships(friendships[1], friendship2);
  friendships = await friendshipRepo.get(testUser4.cognitoId);
  expect(friendships.length).toEqual(1);
  compareFriendships(friendships[0], friendship4);
});

test("Get friendship by cognito IDs", async () => {
  const gymRepo = gymRepository();
  const userRepo = userRepository();
  const friendshipRepo = friendshipRepository();
  const gym = await gymRepo.create(testGym1);
  const user1 = await userRepo.create({ ...testUser1, gymId: gym._id });
  const user2 = await userRepo.create({ ...testUser2, gymId: gym._id });
  const user3 = await userRepo.create({ ...testUser3, gymId: gym._id });
  const friendship1 = await friendshipRepo.create(testFriendship1);
  let result = await friendshipRepo.getByUsers(testFriendship1);
  result.tap({
    left: (friendship) => {
      compareFriendships(friendship, friendship1);
    },
    right: (failure) => {
      fail(`Expected to find friendship, but got ${failure}`);
    },
  });
  const friendship2 = await friendshipRepo.create(testFriendship2);
  result = await friendshipRepo.getByUsers(testFriendship2);
  result.tap({
    left: (friendship) => {
      compareFriendships(friendship, friendship2);
    },
    right: (failure) => {
      fail(`Expected to find friendship, but got ${failure}`);
    },
  });
  const friendship3 = await friendshipRepo.create(testFriendship3);
  result = await friendshipRepo.getByUsers(testFriendship3);
  result.tap({
    left: (friendship) => {
      compareFriendships(friendship, friendship3);
    },
    right: (failure) => {
      fail(`Expected to find friendship, but got ${failure}`);
    },
  });
  const friendship4 = await friendshipRepo.create(testFriendship4);
  result = await friendshipRepo.getByUsers(testFriendship4);
  result.tap({
    left: (friendship) => {
      compareFriendships(friendship, friendship4);
    },
    right: (failure) => {
      fail(`Expected to find friendship, but got ${failure}`);
    },
  });
  result = await friendshipRepo.getByUsers(["fakeId", "fakeId2"]);
  result.tap({
    left: (friendship) => {
      fail(`Expected to find friendship, but got ${friendship}`);
    },
    right: (failure) => {
      expect(failure).toBe(kFriendshipNotFound);
    },
  });
});

test("Delete friendships", async () => {
  const gymRepo = gymRepository();
  const userRepo = userRepository();
  const friendshipRepo = friendshipRepository();
  const gym = await gymRepo.create(testGym1);
  const user1 = await userRepo.create({ ...testUser1, gymId: gym._id });
  const user2 = await userRepo.create({ ...testUser2, gymId: gym._id });
  const user3 = await userRepo.create({ ...testUser3, gymId: gym._id });
  const friendship1 = await friendshipRepo.create(testFriendship1);
  const friendship2 = await friendshipRepo.create(testFriendship2);
  const friendship3 = await friendshipRepo.create(testFriendship3);
  const friendship4 = await friendshipRepo.create(testFriendship4);
  expect(await friendshipRepo.delete(testFriendship1)).toBeUndefined();
  let check = await friendshipRepo.getByUsers(testFriendship1);
  check.tap({
    left: (friendship) => {
      fail(`Expected to delete friendship, but got ${friendship}`);
    },
    right: (failure) => {
      expect(failure).toBe(kFriendshipNotFound);
    },
  });
  expect(await friendshipRepo.delete(testFriendship2)).toBeUndefined();
  check = await friendshipRepo.getByUsers(testFriendship2);
  check.tap({
    left: (friendship) => {
      fail(`Expected to delete friendship, but got ${friendship}`);
    },
    right: (failure) => {
      expect(failure).toBe(kFriendshipNotFound);
    },
  });
  expect(await friendshipRepo.delete(testFriendship3)).toBeUndefined();
  check = await friendshipRepo.getByUsers(testFriendship3);
  check.tap({
    left: (friendship) => {
      fail(`Expected to delete friendship, but got ${friendship}`);
    },
    right: (failure) => {
      expect(failure).toBe(kFriendshipNotFound);
    },
  });
  expect(await friendshipRepo.delete(testFriendship4)).toBeUndefined();
  check = await friendshipRepo.getByUsers(testFriendship4);
  check.tap({
    left: (friendship) => {
      fail(`Expected to delete friendship, but got ${friendship}`);
    },
    right: (failure) => {
      expect(failure).toBe(kFriendshipNotFound);
    },
  });
  expect(await friendshipRepo.delete(["fakeId", "fakeId2"])).toBe(
    kFriendshipNotFound
  );
});
