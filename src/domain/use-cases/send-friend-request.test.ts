import {
  compareFriendRequests,
  compareFriendships,
} from "../../../test/helpers/comparisons";
import {
  kFriendRequestAlreadySent,
  kFriendRequestNotFound,
  kFriendshipAlreadyExists,
  kUsersHaveDifferentGyms,
} from "../../common/failures";
import { IFriendRequestEntity, IFriendshipEntity } from "../entities";
import {
  gymRepo,
  userRepo,
  friendRequestRepo,
  friendshipRepo,
} from "../repositories";
import { sendFriendRequest } from "./send-friend-request";

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
  cognitoId: "cognitoId1",
  firstName: "firstName1",
  lastName: "lastName1",
  email: "abc1@email.com",
};

const testUser2 = {
  cognitoId: "cognitoId2",
  firstName: "firstName2",
  lastName: "lastName2",
  email: "abc2@email.com",
};

const testUser3 = {
  cognitoId: "cognitoId3",
  firstName: "firstName3",
  lastName: "lastName3",
  email: "abc3@email.com",
};

afterEach(async () => {
  await gymRepo.deleteAll();
  await userRepo.deleteAll();
  await friendRequestRepo.deleteAll();
  await friendshipRepo.deleteAll();
});

test("Send friend request to previously denied user", async () => {
  const gym1 = await gymRepo.create(testGym1);
  const user1 = await userRepo.create({
    ...testUser1,
    gymId: gym1._id,
  });
  const user2 = await userRepo.create({
    ...testUser2,
    gymId: gym1._id,
  });
  const friendRequest = (await sendFriendRequest(
    user1.cognitoId,
    user2.cognitoId
  )) as IFriendRequestEntity;
  expect(
    await friendRequestRepo.deny(user1.cognitoId, user2.cognitoId)
  ).toBeUndefined();
  const friendship = (await sendFriendRequest(
    user2.cognitoId,
    user1.cognitoId
  )) as IFriendshipEntity;
  compareFriendships(
    friendship,
    (await friendshipRepo.getByUsers([
      user1.cognitoId,
      user2.cognitoId,
    ])) as IFriendshipEntity
  );
});

test("Send friend request", async () => {
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
  const friendRequest = (await sendFriendRequest(
    user1.cognitoId,
    user2.cognitoId
  )) as IFriendRequestEntity;
  compareFriendRequests(
    friendRequest,
    (await friendRequestRepo.getByCognitoIds(
      user1.cognitoId,
      user2.cognitoId
    )) as IFriendRequestEntity
  );
  expect(await sendFriendRequest(user1.cognitoId, user2.cognitoId)).toBe(
    kFriendRequestAlreadySent
  );
  expect(await sendFriendRequest(user1.cognitoId, user3.cognitoId)).toBe(
    kUsersHaveDifferentGyms
  );
  const friendship = (await sendFriendRequest(
    user2.cognitoId,
    user1.cognitoId
  )) as IFriendshipEntity;
  compareFriendships(
    friendship,
    (await friendshipRepo.getByUsers([
      user1.cognitoId,
      user2.cognitoId,
    ])) as IFriendshipEntity
  );
  expect(
    await friendRequestRepo.getByCognitoIds(user1.cognitoId, user2.cognitoId)
  ).toBe(kFriendRequestNotFound);
  expect(
    await friendRequestRepo.getByCognitoIds(user2.cognitoId, user1.cognitoId)
  ).toBe(kFriendRequestNotFound);
  expect(await sendFriendRequest(user1.cognitoId, user2.cognitoId)).toBe(
    kFriendshipAlreadyExists
  );
});
