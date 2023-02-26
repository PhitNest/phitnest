import {
  compareFriendRequests,
  compareProfilePicturePublicUsers,
  comparePublicUsers,
} from "../../../test/helpers/comparisons";
import { explore } from "./explore";
import databases, {
  injectDatabases,
  rebindDatabases,
} from "../../data/data-sources/injection";
import { MockProfilePictureDatabase } from "../../../test/helpers/mock-s3";

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
  await databases().gymDatabase.deleteAll();
  await databases().userDatabase.deleteAll();
  await databases().friendRequestDatabase.deleteAll();
  await databases().friendshipDatabase.deleteAll();
});

test("Explore users", async () => {
  const gym1 = await databases().gymDatabase.create(testGym1);
  const gym2 = await databases().gymDatabase.create(testGym2);
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
  const user5 = await databases().userDatabase.create({
    ...testUser5,
    gymId: gym2._id,
  });
  rebindDatabases({
    profilePictureDatabase: new MockProfilePictureDatabase(user4.cognitoId),
  });
  let result = await explore(user1.cognitoId, user1.gymId);
  expect(result.length).toBe(0);
  await databases().userDatabase.setConfirmed(user1.cognitoId);
  await databases().userDatabase.setConfirmed(user2.cognitoId);
  await databases().userDatabase.setConfirmed(user3.cognitoId);
  await databases().userDatabase.setConfirmed(user4.cognitoId);
  await databases().userDatabase.setConfirmed(user5.cognitoId);
  result = await explore(user1.cognitoId, user1.gymId);
  expect(result.length).toBe(2);
  compareProfilePicturePublicUsers(result[0], {
    ...user2,
    profilePictureUrl: "get",
  });
  compareProfilePicturePublicUsers(result[1], {
    ...user3,
    profilePictureUrl: "get",
  });
  rebindDatabases({
    profilePictureDatabase: new MockProfilePictureDatabase(""),
  });
  result = await explore(user1.cognitoId, user1.gymId);
  expect(result.length).toBe(3);
  comparePublicUsers(result[0], user2);
  comparePublicUsers(result[1], user3);
  comparePublicUsers(result[2], user4);
  result = await explore(user2.cognitoId, user2.gymId);
  expect(result.length).toBe(3);
  comparePublicUsers(result[0], user1);
  comparePublicUsers(result[1], user3);
  comparePublicUsers(result[2], user4);
  result = await explore(user5.cognitoId, user5.gymId);
  expect(result.length).toBe(0);
  const friendRequest1 = await databases().friendRequestDatabase.create(
    user1.cognitoId,
    user2.cognitoId
  );
  result = await explore(user1.cognitoId, user1.gymId);
  expect(result.length).toBe(2);
  comparePublicUsers(result[0], user3);
  comparePublicUsers(result[1], user4);
  result = await explore(user2.cognitoId, user2.gymId);
  expect(result.length).toBe(3);
  comparePublicUsers(result[0], user1);
  comparePublicUsers(result[1], user3);
  comparePublicUsers(result[2], user4);
  await databases().friendRequestDatabase.deny(
    user1.cognitoId,
    user2.cognitoId
  );
  result = await explore(user2.cognitoId, user2.gymId);
  expect(result.length).toBe(2);
  comparePublicUsers(result[0], user3);
  comparePublicUsers(result[1], user4);
  const friendship = await databases().friendshipDatabase.create([
    user2.cognitoId,
    user4.cognitoId,
  ]);
  result = await explore(user2.cognitoId, user2.gymId);
  expect(result.length).toBe(1);
  comparePublicUsers(result[0], user3);
  injectDatabases();
});
