import { fail } from "assert";
import { compareFriendRequests } from "../../../test/helpers/comparisons";
import { kFriendRequestNotFound } from "../../common/failures";
import {
  friendRequestRepository,
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

const testFriendRequest1 = {
  fromCognitoId: "testCognitoId1",
  toCognitoId: "testCognitoId2",
};

const testFriendRequest2 = {
  fromCognitoId: "testCognitoId2",
  toCognitoId: "testCognitoId1",
};

const testFriendRequest3 = {
  fromCognitoId: "testCognitoId1",
  toCognitoId: "testCognitoId3",
};

const testFriendRequest4 = {
  fromCognitoId: "testCognitoId3",
  toCognitoId: "testCognitoId2",
};

afterEach(async () => {
  const gymRepo = gymRepository();
  const userRepo = userRepository();
  const friendRequestRepo = friendRequestRepository();
  await gymRepo.deleteAll();
  await userRepo.deleteAll();
  await friendRequestRepo.deleteAll();
});

test("Create friend request", async () => {
  const gymRepo = gymRepository();
  const userRepo = userRepository();
  const friendRequestRepo = friendRequestRepository();
  const gym = await gymRepo.create(testGym1);
  const user1 = await userRepo.create({ ...testUser1, gymId: gym._id });
  const user2 = await userRepo.create({ ...testUser2, gymId: gym._id });
  const user3 = await userRepo.create({ ...testUser3, gymId: gym._id });
  let friendRequest = await friendRequestRepo.create(
    testFriendRequest1.fromCognitoId,
    testFriendRequest1.toCognitoId
  );
  compareFriendRequests(friendRequest, {
    ...testFriendRequest1,
    _id: friendRequest._id,
    createdAt: friendRequest.createdAt,
  });
  friendRequest = await friendRequestRepo.create(
    testFriendRequest2.fromCognitoId,
    testFriendRequest2.toCognitoId
  );
  compareFriendRequests(friendRequest, {
    ...testFriendRequest2,
    _id: friendRequest._id,
    createdAt: friendRequest.createdAt,
  });
  friendRequest = await friendRequestRepo.create(
    testFriendRequest3.fromCognitoId,
    testFriendRequest3.toCognitoId
  );
  compareFriendRequests(friendRequest, {
    ...testFriendRequest3,
    _id: friendRequest._id,
    createdAt: friendRequest.createdAt,
  });
  friendRequest = await friendRequestRepo.create(
    testFriendRequest4.fromCognitoId,
    testFriendRequest4.toCognitoId
  );
  compareFriendRequests(friendRequest, {
    ...testFriendRequest4,
    _id: friendRequest._id,
    createdAt: friendRequest.createdAt,
  });
});

test("Get friend requests by fromCognitoId and toCognitoId", async () => {
  const gymRepo = gymRepository();
  const userRepo = userRepository();
  const friendRequestRepo = friendRequestRepository();
  const gym = await gymRepo.create(testGym1);
  const user1 = await userRepo.create({ ...testUser1, gymId: gym._id });
  const user2 = await userRepo.create({ ...testUser2, gymId: gym._id });
  const user3 = await userRepo.create({ ...testUser3, gymId: gym._id });
  await friendRequestRepo.create(
    testFriendRequest1.fromCognitoId,
    testFriendRequest1.toCognitoId
  );
  await friendRequestRepo.create(
    testFriendRequest2.fromCognitoId,
    testFriendRequest2.toCognitoId
  );
  await friendRequestRepo.create(
    testFriendRequest3.fromCognitoId,
    testFriendRequest3.toCognitoId
  );
  await friendRequestRepo.create(
    testFriendRequest4.fromCognitoId,
    testFriendRequest4.toCognitoId
  );
  let friendRequests = await friendRequestRepo.getByFromCognitoId(
    testUser1.cognitoId
  );
  expect(friendRequests.length).toBe(2);
  compareFriendRequests(friendRequests[0], {
    ...testFriendRequest3,
    _id: friendRequests[0]._id,
    createdAt: friendRequests[0].createdAt,
  });
  compareFriendRequests(friendRequests[1], {
    ...testFriendRequest1,
    _id: friendRequests[1]._id,
    createdAt: friendRequests[1].createdAt,
  });
  friendRequests = await friendRequestRepo.getByFromCognitoId(
    testUser2.cognitoId
  );
  expect(friendRequests.length).toBe(1);
  compareFriendRequests(friendRequests[0], {
    ...testFriendRequest2,
    _id: friendRequests[0]._id,
    createdAt: friendRequests[0].createdAt,
  });
  friendRequests = await friendRequestRepo.getByFromCognitoId(
    testUser3.cognitoId
  );
  friendRequests = await friendRequestRepo.getByToCognitoId("fakeId");
  expect(friendRequests.length).toBe(0);
  friendRequests = await friendRequestRepo.getByToCognitoId(
    testUser1.cognitoId
  );
  expect(friendRequests.length).toBe(1);
  compareFriendRequests(friendRequests[0], {
    ...testFriendRequest2,
    _id: friendRequests[0]._id,
    createdAt: friendRequests[0].createdAt,
  });
  friendRequests = await friendRequestRepo.getByToCognitoId(
    testUser2.cognitoId
  );
  expect(friendRequests.length).toBe(2);
  compareFriendRequests(friendRequests[0], {
    ...testFriendRequest4,
    _id: friendRequests[0]._id,
    createdAt: friendRequests[0].createdAt,
  });
  compareFriendRequests(friendRequests[1], {
    ...testFriendRequest1,
    _id: friendRequests[1]._id,
    createdAt: friendRequests[1].createdAt,
  });
  friendRequests = await friendRequestRepo.getByToCognitoId(
    testUser3.cognitoId
  );
  expect(friendRequests.length).toBe(1);
  compareFriendRequests(friendRequests[0], {
    ...testFriendRequest3,
    _id: friendRequests[0]._id,
    createdAt: friendRequests[0].createdAt,
  });
  let friendRequest = await friendRequestRepo.getByCognitoIds(
    testUser1.cognitoId,
    testUser2.cognitoId
  );
  friendRequest.tap({
    right: (friendRequest) => {
      compareFriendRequests(friendRequest, {
        ...testFriendRequest1,
        _id: friendRequest._id,
        createdAt: friendRequest.createdAt,
      });
    },
    right: (failure) => {
      fail(`Expected friend request, got ${failure}`);
    },
  });
  friendRequest = await friendRequestRepo.getByCognitoIds(
    testUser2.cognitoId,
    testUser1.cognitoId
  );
  friendRequest.tap({
    left: (friendRequest) => {
      compareFriendRequests(friendRequest, {
        ...testFriendRequest2,
        _id: friendRequest._id,
        createdAt: friendRequest.createdAt,
      });
    },
    right: (failure) => {
      fail(`Expected friend request, got ${failure}`);
    },
  });
  friendRequest = await friendRequestRepo.getByCognitoIds(
    testUser1.cognitoId,
    testUser3.cognitoId
  );
  friendRequest.tap({
    left: (friendRequest) => {
      compareFriendRequests(friendRequest, {
        ...testFriendRequest3,
        _id: friendRequest._id,
        createdAt: friendRequest.createdAt,
      });
    },
    right: (failure) => {
      fail(`Expected friend request, got ${failure}`);
    },
  });
  friendRequest = await friendRequestRepo.getByCognitoIds(
    testUser3.cognitoId,
    testUser2.cognitoId
  );
  friendRequest.tap({
    left: (friendRequest) => {
      compareFriendRequests(friendRequest, {
        ...testFriendRequest4,
        _id: friendRequest._id,
        createdAt: friendRequest.createdAt,
      });
    },
    right: (failure) => {
      fail(`Expected friend request, got ${failure}`);
    },
  });
});

test("Delete friend request", async () => {
  const gymRepo = gymRepository();
  const userRepo = userRepository();
  const friendRequestRepo = friendRequestRepository();
  const gym = await gymRepo.create(testGym1);
  const user1 = await userRepo.create({ ...testUser1, gymId: gym._id });
  const user2 = await userRepo.create({ ...testUser2, gymId: gym._id });
  const user3 = await userRepo.create({ ...testUser3, gymId: gym._id });
  await friendRequestRepo.create(
    testFriendRequest1.fromCognitoId,
    testFriendRequest1.toCognitoId
  );
  await friendRequestRepo.create(
    testFriendRequest2.fromCognitoId,
    testFriendRequest2.toCognitoId
  );
  await friendRequestRepo.create(
    testFriendRequest3.fromCognitoId,
    testFriendRequest3.toCognitoId
  );
  await friendRequestRepo.create(
    testFriendRequest4.fromCognitoId,
    testFriendRequest4.toCognitoId
  );
  await friendRequestRepo.delete(
    testFriendRequest1.fromCognitoId,
    testFriendRequest1.toCognitoId
  );
  let friendRequests = await friendRequestRepo.getByCognitoIds(
    testFriendRequest1.fromCognitoId,
    testFriendRequest1.toCognitoId
  );
  friendRequests.tap({
    left: (friendRequest) => {
      fail(`Expected failure, but got ${friendRequest}`);
    },
    right: (failure) => {
      expect(failure).toBe(kFriendRequestNotFound);
    },
  });
  await friendRequestRepo.delete(
    testFriendRequest2.fromCognitoId,
    testFriendRequest2.toCognitoId
  );
  friendRequests = await friendRequestRepo.getByCognitoIds(
    testFriendRequest2.fromCognitoId,
    testFriendRequest2.toCognitoId
  );
  friendRequests.tap({
    left: (friendRequest) => {
      fail(`Expected failure, but got ${friendRequest}`);
    },
    right: (failure) => {
      expect(failure).toBe(kFriendRequestNotFound);
    },
  });
  await friendRequestRepo.delete(
    testFriendRequest3.fromCognitoId,
    testFriendRequest3.toCognitoId
  );
  friendRequests = await friendRequestRepo.getByCognitoIds(
    testFriendRequest3.fromCognitoId,
    testFriendRequest3.toCognitoId
  );
  friendRequests.tap({
    left: (friendRequest) => {
      fail(`Expected failure, but got ${friendRequest}`);
    },
    right: (failure) => {
      expect(failure).toBe(kFriendRequestNotFound);
    },
  });
  await friendRequestRepo.delete(
    testFriendRequest4.fromCognitoId,
    testFriendRequest4.toCognitoId
  );
  friendRequests = await friendRequestRepo.getByCognitoIds(
    testFriendRequest4.fromCognitoId,
    testFriendRequest4.toCognitoId
  );
  friendRequests.tap({
    left: (friendRequest) => {
      fail(`Expected failure, but got ${friendRequest}`);
    },
    right: (failure) => {
      expect(failure).toBe(kFriendRequestNotFound);
    },
  });
  expect(
    await friendRequestRepo.delete(
      testFriendRequest1.fromCognitoId,
      testFriendRequest1.toCognitoId
    )
  ).toBe(kFriendRequestNotFound);
});
