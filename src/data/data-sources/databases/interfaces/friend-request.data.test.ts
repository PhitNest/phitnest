import { compareFriendRequests } from "../../../../../test/helpers/comparisons";
import { kFriendRequestNotFound } from "../../../../common/failures";
import { IFriendRequestEntity } from "../../../../domain/entities";
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
  const { gymDatabase, userDatabase, friendRequestDatabase } = dataSources();
  await gymDatabase.deleteAll();
  await userDatabase.deleteAll();
  await friendRequestDatabase.deleteAll();
});

test("Create friend request", async () => {
  const { gymDatabase, userDatabase, friendRequestDatabase } = dataSources();
  const gym = await gymDatabase.create(testGym1);
  await userDatabase.create({ ...testUser1, gymId: gym._id });
  await userDatabase.create({ ...testUser2, gymId: gym._id });
  await userDatabase.create({ ...testUser3, gymId: gym._id });
  let friendRequest = await friendRequestDatabase.create(
    testFriendRequest1.fromCognitoId,
    testFriendRequest1.toCognitoId
  );
  compareFriendRequests(friendRequest, {
    ...testFriendRequest1,
    _id: friendRequest._id,
    createdAt: friendRequest.createdAt,
    denied: false,
  });
  friendRequest = await friendRequestDatabase.create(
    testFriendRequest2.fromCognitoId,
    testFriendRequest2.toCognitoId
  );
  compareFriendRequests(friendRequest, {
    ...testFriendRequest2,
    _id: friendRequest._id,
    createdAt: friendRequest.createdAt,
    denied: false,
  });
  friendRequest = await friendRequestDatabase.create(
    testFriendRequest3.fromCognitoId,
    testFriendRequest3.toCognitoId
  );
  compareFriendRequests(friendRequest, {
    ...testFriendRequest3,
    _id: friendRequest._id,
    createdAt: friendRequest.createdAt,
    denied: false,
  });
  friendRequest = await friendRequestDatabase.create(
    testFriendRequest4.fromCognitoId,
    testFriendRequest4.toCognitoId
  );
  compareFriendRequests(friendRequest, {
    ...testFriendRequest4,
    _id: friendRequest._id,
    createdAt: friendRequest.createdAt,
    denied: false,
  });
});

test("Deny friend request", async () => {
  const { gymDatabase, userDatabase, friendRequestDatabase } = dataSources();
  const gym = await gymDatabase.create(testGym1);
  await userDatabase.create({ ...testUser1, gymId: gym._id });
  await userDatabase.create({ ...testUser2, gymId: gym._id });
  expect(await friendRequestDatabase.deny("", "")).toBe(kFriendRequestNotFound);
  const friendRequest = (await friendRequestDatabase.create(
    testFriendRequest1.fromCognitoId,
    testFriendRequest1.toCognitoId
  )) as IFriendRequestEntity;
  expect(
    await friendRequestDatabase.deny(
      testFriendRequest1.fromCognitoId,
      testFriendRequest1.toCognitoId
    )
  ).toBeUndefined();
  friendRequest.denied = true;
  compareFriendRequests(
    friendRequest,
    (await friendRequestDatabase.getByCognitoIds(
      testFriendRequest1.fromCognitoId,
      testFriendRequest1.toCognitoId
    )) as IFriendRequestEntity
  );
});

test("Get friend requests by fromCognitoId and toCognitoId", async () => {
  const { gymDatabase, userDatabase, friendRequestDatabase } = dataSources();
  const gym = await gymDatabase.create(testGym1);
  await userDatabase.create({ ...testUser1, gymId: gym._id });
  await userDatabase.create({ ...testUser2, gymId: gym._id });
  await userDatabase.create({ ...testUser3, gymId: gym._id });
  await friendRequestDatabase.create(
    testFriendRequest1.fromCognitoId,
    testFriendRequest1.toCognitoId
  );
  await friendRequestDatabase.create(
    testFriendRequest2.fromCognitoId,
    testFriendRequest2.toCognitoId
  );
  await friendRequestDatabase.create(
    testFriendRequest3.fromCognitoId,
    testFriendRequest3.toCognitoId
  );
  await friendRequestDatabase.create(
    testFriendRequest4.fromCognitoId,
    testFriendRequest4.toCognitoId
  );
  let friendRequests = await friendRequestDatabase.getByFromCognitoId(
    testUser1.cognitoId
  );
  expect(friendRequests.length).toBe(2);
  compareFriendRequests(friendRequests[0], {
    ...testFriendRequest3,
    _id: friendRequests[0]._id,
    createdAt: friendRequests[0].createdAt,
    denied: false,
  });
  compareFriendRequests(friendRequests[1], {
    ...testFriendRequest1,
    _id: friendRequests[1]._id,
    createdAt: friendRequests[1].createdAt,
    denied: false,
  });
  friendRequests = await friendRequestDatabase.getByFromCognitoId(
    testUser2.cognitoId
  );
  expect(friendRequests.length).toBe(1);
  compareFriendRequests(friendRequests[0], {
    ...testFriendRequest2,
    _id: friendRequests[0]._id,
    createdAt: friendRequests[0].createdAt,
    denied: false,
  });
  friendRequests = await friendRequestDatabase.getByFromCognitoId(
    testUser3.cognitoId
  );
  friendRequests = await friendRequestDatabase.getByToCognitoId("fakeId");
  expect(friendRequests.length).toBe(0);
  friendRequests = await friendRequestDatabase.getByToCognitoId(
    testUser1.cognitoId
  );
  expect(friendRequests.length).toBe(1);
  compareFriendRequests(friendRequests[0], {
    ...testFriendRequest2,
    _id: friendRequests[0]._id,
    createdAt: friendRequests[0].createdAt,
    denied: false,
  });
  friendRequests = await friendRequestDatabase.getByToCognitoId(
    testUser2.cognitoId
  );
  expect(friendRequests.length).toBe(2);
  compareFriendRequests(friendRequests[0], {
    ...testFriendRequest4,
    _id: friendRequests[0]._id,
    createdAt: friendRequests[0].createdAt,
    denied: false,
  });
  compareFriendRequests(friendRequests[1], {
    ...testFriendRequest1,
    _id: friendRequests[1]._id,
    createdAt: friendRequests[1].createdAt,
    denied: false,
  });
  friendRequests = await friendRequestDatabase.getByToCognitoId(
    testUser3.cognitoId
  );
  expect(friendRequests.length).toBe(1);
  compareFriendRequests(friendRequests[0], {
    ...testFriendRequest3,
    _id: friendRequests[0]._id,
    createdAt: friendRequests[0].createdAt,
    denied: false,
  });
  let friendRequest = (await friendRequestDatabase.getByCognitoIds(
    testUser1.cognitoId,
    testUser2.cognitoId
  )) as IFriendRequestEntity;
  compareFriendRequests(friendRequest, {
    ...testFriendRequest1,
    _id: friendRequest._id,
    createdAt: friendRequest.createdAt,
    denied: false,
  });
  friendRequest = (await friendRequestDatabase.getByCognitoIds(
    testUser2.cognitoId,
    testUser1.cognitoId
  )) as IFriendRequestEntity;
  compareFriendRequests(friendRequest, {
    ...testFriendRequest2,
    _id: friendRequest._id,
    createdAt: friendRequest.createdAt,
    denied: false,
  });
  friendRequest = (await friendRequestDatabase.getByCognitoIds(
    testUser1.cognitoId,
    testUser3.cognitoId
  )) as IFriendRequestEntity;
  compareFriendRequests(friendRequest, {
    ...testFriendRequest3,
    _id: friendRequest._id,
    createdAt: friendRequest.createdAt,
    denied: false,
  });
  friendRequest = (await friendRequestDatabase.getByCognitoIds(
    testUser3.cognitoId,
    testUser2.cognitoId
  )) as IFriendRequestEntity;
  compareFriendRequests(friendRequest, {
    ...testFriendRequest4,
    _id: friendRequest._id,
    createdAt: friendRequest.createdAt,
    denied: false,
  });
});

test("Delete friend request", async () => {
  const { gymDatabase, userDatabase, friendRequestDatabase } = dataSources();
  const gym = await gymDatabase.create(testGym1);
  await userDatabase.create({ ...testUser1, gymId: gym._id });
  await userDatabase.create({ ...testUser2, gymId: gym._id });
  await userDatabase.create({ ...testUser3, gymId: gym._id });
  await friendRequestDatabase.create(
    testFriendRequest1.fromCognitoId,
    testFriendRequest1.toCognitoId
  );
  await friendRequestDatabase.create(
    testFriendRequest2.fromCognitoId,
    testFriendRequest2.toCognitoId
  );
  await friendRequestDatabase.create(
    testFriendRequest3.fromCognitoId,
    testFriendRequest3.toCognitoId
  );
  await friendRequestDatabase.create(
    testFriendRequest4.fromCognitoId,
    testFriendRequest4.toCognitoId
  );
  await friendRequestDatabase.delete(
    testFriendRequest1.fromCognitoId,
    testFriendRequest1.toCognitoId
  );
  expect(
    await friendRequestDatabase.getByCognitoIds(
      testFriendRequest1.fromCognitoId,
      testFriendRequest1.toCognitoId
    )
  ).toBe(kFriendRequestNotFound);
  await friendRequestDatabase.delete(
    testFriendRequest2.fromCognitoId,
    testFriendRequest2.toCognitoId
  );
  expect(
    await friendRequestDatabase.getByCognitoIds(
      testFriendRequest2.fromCognitoId,
      testFriendRequest2.toCognitoId
    )
  ).toBe(kFriendRequestNotFound);
  await friendRequestDatabase.delete(
    testFriendRequest3.fromCognitoId,
    testFriendRequest3.toCognitoId
  );
  expect(
    await friendRequestDatabase.getByCognitoIds(
      testFriendRequest3.fromCognitoId,
      testFriendRequest3.toCognitoId
    )
  ).toBe(kFriendRequestNotFound);
  await friendRequestDatabase.delete(
    testFriendRequest4.fromCognitoId,
    testFriendRequest4.toCognitoId
  );
  expect(
    await friendRequestDatabase.getByCognitoIds(
      testFriendRequest4.fromCognitoId,
      testFriendRequest4.toCognitoId
    )
  ).toBe(kFriendRequestNotFound);
  expect(
    await friendRequestDatabase.delete(
      testFriendRequest1.fromCognitoId,
      testFriendRequest1.toCognitoId
    )
  ).toBe(kFriendRequestNotFound);
});
