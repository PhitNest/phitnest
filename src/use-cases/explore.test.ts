import {
  compareFriendRequests,
  compareProfilePicturePublicUsers,
  comparePublicUsers,
} from "../../test/helpers/comparisons";
import { MockProfilePictureRepo } from "../../test/helpers/mock-s3";
import repositories, {
  injectRepositories,
  rebindRepositories,
} from "../repositories/injection";
import { explore } from "./explore";

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

const testUser5 = {
  cognitoId: "cognitoId5",
  firstName: "firstName5",
  lastName: "lastName5",
  email: "abc5@email.com",
};

afterEach(async () => {
  const { gymRepo, userRepo, friendRequestRepo, friendshipRepo } =
    repositories();
  await gymRepo.deleteAll();
  await userRepo.deleteAll();
  await friendRequestRepo.deleteAll();
  await friendshipRepo.deleteAll();
});

test("Explore users", async () => {
  const { gymRepo, userRepo, friendRequestRepo, friendshipRepo } =
    repositories();
  const gym1 = await gymRepo.create(testGym1);
  const gym2 = await gymRepo.create(testGym2);
  const user1 = await userRepo.create({ ...testUser1, gymId: gym1._id });
  const user2 = await userRepo.create({ ...testUser2, gymId: gym1._id });
  const user3 = await userRepo.create({ ...testUser3, gymId: gym1._id });
  const user4 = await userRepo.create({ ...testUser4, gymId: gym1._id });
  const user5 = await userRepo.create({ ...testUser5, gymId: gym2._id });
  rebindRepositories({
    profilePictureRepo: new MockProfilePictureRepo(user4.cognitoId),
  });
  let result = await explore(user1.cognitoId, user1.gymId);
  expect(result.users.length).toBe(0);
  expect(result.requests.length).toBe(0);
  await userRepo.setConfirmed(user1.cognitoId);
  await userRepo.setConfirmed(user2.cognitoId);
  await userRepo.setConfirmed(user3.cognitoId);
  await userRepo.setConfirmed(user4.cognitoId);
  await userRepo.setConfirmed(user5.cognitoId);
  result = await explore(user1.cognitoId, user1.gymId);
  expect(result.users.length).toBe(2);
  compareProfilePicturePublicUsers(result.users[0], {
    ...user2,
    profilePictureUrl: "get",
  });
  compareProfilePicturePublicUsers(result.users[1], {
    ...user3,
    profilePictureUrl: "get",
  });
  expect(result.requests.length).toBe(0);
  rebindRepositories({
    profilePictureRepo: new MockProfilePictureRepo(""),
  });
  result = await explore(user1.cognitoId, user1.gymId);
  expect(result.users.length).toBe(3);
  comparePublicUsers(result.users[0], user2);
  comparePublicUsers(result.users[1], user3);
  comparePublicUsers(result.users[2], user4);
  expect(result.requests.length).toBe(0);
  result = await explore(user2.cognitoId, user2.gymId);
  expect(result.users.length).toBe(3);
  comparePublicUsers(result.users[0], user1);
  comparePublicUsers(result.users[1], user3);
  comparePublicUsers(result.users[2], user4);
  expect(result.requests.length).toBe(0);
  result = await explore(user5.cognitoId, user5.gymId);
  expect(result.users.length).toBe(0);
  expect(result.requests.length).toBe(0);
  const friendRequest1 = await friendRequestRepo.create(
    user1.cognitoId,
    user2.cognitoId
  );
  result = await explore(user1.cognitoId, user1.gymId);
  expect(result.users.length).toBe(2);
  comparePublicUsers(result.users[0], user3);
  comparePublicUsers(result.users[1], user4);
  expect(result.requests.length).toBe(0);
  result = await explore(user2.cognitoId, user2.gymId);
  expect(result.users.length).toBe(3);
  comparePublicUsers(result.users[0], user1);
  comparePublicUsers(result.users[1], user3);
  comparePublicUsers(result.users[2], user4);
  expect(result.requests.length).toBe(1);
  compareFriendRequests(result.requests[0], friendRequest1);
  await friendRequestRepo.deny(user1.cognitoId, user2.cognitoId);
  result = await explore(user2.cognitoId, user2.gymId);
  expect(result.users.length).toBe(2);
  comparePublicUsers(result.users[0], user3);
  comparePublicUsers(result.users[1], user4);
  expect(result.requests.length).toBe(0);
  const friendship = await friendshipRepo.create([
    user2.cognitoId,
    user4.cognitoId,
  ]);
  result = await explore(user2.cognitoId, user2.gymId);
  expect(result.users.length).toBe(1);
  comparePublicUsers(result.users[0], user3);
  expect(result.requests.length).toBe(0);
  injectRepositories();
});
