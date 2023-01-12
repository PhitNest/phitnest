import {
  compareFriendRequests,
  compareFriendships,
  comparePublicUsers,
} from "../../test/helpers/comparisons";
import repositories from "../repositories/injection";
import { getFriendsAndFriendRequests } from "./friends-and-requests";

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

const testUser4 = {
  cognitoId: "cognitoId4",
  firstName: "firstName4",
  lastName: "lastName4",
  email: "abc4@email.com",
};

afterEach(async () => {
  const { gymRepo, userRepo, friendRequestRepo, friendshipRepo } =
    repositories();
  await gymRepo.deleteAll();
  await userRepo.deleteAll();
  await friendRequestRepo.deleteAll();
  await friendshipRepo.deleteAll();
});

test("Get friends and friends requests populated", async () => {
  const { gymRepo, userRepo, friendRequestRepo, friendshipRepo } =
    repositories();
  const gym1 = await gymRepo.create(testGym1);
  const user1 = await userRepo.create({ ...testUser1, gymId: gym1._id });
  const user2 = await userRepo.create({ ...testUser2, gymId: gym1._id });
  const user3 = await userRepo.create({ ...testUser3, gymId: gym1._id });
  const user4 = await userRepo.create({ ...testUser4, gymId: gym1._id });
  const friendRequest1 = await friendRequestRepo.create(
    user1.cognitoId,
    user2.cognitoId
  );
  let result = await getFriendsAndFriendRequests(user1.cognitoId);
  expect(result.friendships.length).toBe(0);
  expect(result.requests.length).toBe(0);
  result = await getFriendsAndFriendRequests(user2.cognitoId);
  expect(result.friendships.length).toBe(0);
  expect(result.requests.length).toBe(1);
  compareFriendRequests(result.requests[0], friendRequest1);
  comparePublicUsers(result.requests[0].fromUser, user1);
  const friendship1 = await friendshipRepo.create([
    user2.cognitoId,
    user3.cognitoId,
  ]);
  result = await getFriendsAndFriendRequests(user2.cognitoId);
  expect(result.requests.length).toBe(1);
  compareFriendRequests(result.requests[0], friendRequest1);
  comparePublicUsers(result.requests[0].fromUser, user1);
  expect(result.friendships.length).toBe(1);
  comparePublicUsers(result.friendships[0].friend, user3);
  const friendship2 = await friendshipRepo.create([
    user1.cognitoId,
    user3.cognitoId,
  ]);
  const friendRequest2 = await friendRequestRepo.create(
    user4.cognitoId,
    user3.cognitoId
  );
  result = await getFriendsAndFriendRequests(user3.cognitoId);
  expect(result.requests.length).toBe(1);
  compareFriendRequests(result.requests[0], friendRequest2);
  comparePublicUsers(result.requests[0].fromUser, user4);
  expect(result.friendships.length).toBe(2);
  compareFriendships(result.friendships[0], friendship2);
  compareFriendships(result.friendships[1], friendship1);
  comparePublicUsers(result.friendships[0].friend, user1);
  comparePublicUsers(result.friendships[1].friend, user2);
});
