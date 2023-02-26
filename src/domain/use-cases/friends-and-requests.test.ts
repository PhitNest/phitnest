import {
  compareFriendRequests,
  compareFriendships,
  comparePublicUsers,
} from "../../../test/helpers/comparisons";
import databases from "../../data/data-sources/injection";
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
  await databases().gymDatabase.deleteAll();
  await databases().userDatabase.deleteAll();
  await databases().friendRequestDatabase.deleteAll();
  await databases().friendshipDatabase.deleteAll();
});

test("Get friends and friends requests populated", async () => {
  const gym1 = await databases().gymDatabase.create(testGym1);
  const user1 = await databases().userDatabase.create({
    ...testUser1,
    gymId: gym1._id,
  });
  const user2 = await databases().userDatabase.create({
    ...testUser2,
    gymId: gym1._id,
  });
  const user3 = await databases().userDatabase.create({
    ...testUser3,
    gymId: gym1._id,
  });
  const user4 = await databases().userDatabase.create({
    ...testUser4,
    gymId: gym1._id,
  });
  const friendRequest1 = await databases().friendRequestDatabase.create(
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
  const friendship1 = await databases().friendshipDatabase.create([
    user2.cognitoId,
    user3.cognitoId,
  ]);
  result = await getFriendsAndFriendRequests(user2.cognitoId);
  expect(result.requests.length).toBe(1);
  compareFriendRequests(result.requests[0], friendRequest1);
  comparePublicUsers(result.requests[0].fromUser, user1);
  comparePublicUsers(result.requests[0].toUser, user2);
  expect(result.friendships.length).toBe(1);
  if (result.friendships[0].friends[0].cognitoId === user2.cognitoId) {
    comparePublicUsers(result.friendships[0].friends[1], user3);
  } else {
    comparePublicUsers(result.friendships[0].friends[0], user3);
  }
  const friendship2 = await databases().friendshipDatabase.create([
    user1.cognitoId,
    user3.cognitoId,
  ]);
  const friendRequest2 = await databases().friendRequestDatabase.create(
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
  if (result.friendships[0].friends[0].cognitoId === user1.cognitoId) {
    comparePublicUsers(result.friendships[0].friends[1], user3);
  } else {
    comparePublicUsers(result.friendships[0].friends[0], user3);
  }
  if (result.friendships[1].friends[0].cognitoId === user1.cognitoId) {
    comparePublicUsers(result.friendships[1].friends[1], user2);
  } else {
    comparePublicUsers(result.friendships[1].friends[0], user2);
  }
});
