import { compareDirectMessages } from "../../../test/helpers/comparisons";
import { kDirectMessageNotFound } from "../../common/failures";
import repositories from "../injection";

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

const testMessage1 = {
  senderCognitoId: testUser1.cognitoId,
  text: "testMessage1",
};

const testMessage2 = {
  senderCognitoId: testUser2.cognitoId,
  text: "testMessage2",
};

const testMessage3 = {
  senderCognitoId: testUser3.cognitoId,
  text: "testMessage3",
};

const testMessage4 = {
  senderCognitoId: testUser4.cognitoId,
  text: "testMessage4",
};

const testMessage5 = {
  senderCognitoId: testUser1.cognitoId,
  text: "testMessage5",
};

const testMessage6 = {
  senderCognitoId: testUser2.cognitoId,
  text: "testMessage6",
};

const testMessage7 = {
  senderCognitoId: testUser3.cognitoId,
  text: "testMessage7",
};

afterEach(async () => {
  const { gymRepo, userRepo, friendshipRepo, directMessageRepo } =
    repositories();
  await gymRepo.deleteAll();
  await userRepo.deleteAll();
  await friendshipRepo.deleteAll();
  await directMessageRepo.deleteAll();
});

test("Create and get direct messages", async () => {
  const { gymRepo, userRepo, friendshipRepo, directMessageRepo } =
    repositories();
  const gym = await gymRepo.create(testGym1);
  await userRepo.create({ ...testUser1, gymId: gym._id });
  await userRepo.create({ ...testUser2, gymId: gym._id });
  await userRepo.create({ ...testUser3, gymId: gym._id });
  await userRepo.create({ ...testUser4, gymId: gym._id });
  const friendship1 = await friendshipRepo.create(testFriendship1);
  const friendship2 = await friendshipRepo.create(testFriendship2);
  const friendship3 = await friendshipRepo.create(testFriendship3);
  const friendship4 = await friendshipRepo.create(testFriendship4);
  const message1 = await directMessageRepo.create({
    ...testMessage1,
    friendshipId: friendship1._id,
  });
  let messages = await directMessageRepo.get(friendship1._id);
  expect(messages.length).toBe(1);
  compareDirectMessages(messages[0], message1);
  const message2 = await directMessageRepo.create({
    ...testMessage2,
    friendshipId: friendship1._id,
  });
  messages = await directMessageRepo.get(friendship1._id);
  expect(messages.length).toBe(2);
  compareDirectMessages(messages[0], message2);
  compareDirectMessages(messages[1], message1);
  const message3 = await directMessageRepo.create({
    ...testMessage3,
    friendshipId: friendship2._id,
  });
  messages = await directMessageRepo.get(friendship2._id);
  expect(messages.length).toBe(1);
  compareDirectMessages(messages[0], message3);
  const message4 = await directMessageRepo.create({
    ...testMessage4,
    friendshipId: friendship3._id,
  });
  messages = await directMessageRepo.get(friendship3._id);
  expect(messages.length).toBe(1);
  compareDirectMessages(messages[0], message4);
  const message5 = await directMessageRepo.create({
    ...testMessage5,
    friendshipId: friendship4._id,
  });
  messages = await directMessageRepo.get(friendship4._id);
  expect(messages.length).toBe(1);
  compareDirectMessages(messages[0], message5);
  const message6 = await directMessageRepo.create({
    ...testMessage6,
    friendshipId: friendship4._id,
  });
  messages = await directMessageRepo.get(friendship4._id);
  expect(messages.length).toBe(2);
  compareDirectMessages(messages[0], message6);
  compareDirectMessages(messages[1], message5);
  const message7 = await directMessageRepo.create({
    ...testMessage7,
    friendshipId: friendship4._id,
  });
  messages = await directMessageRepo.get(friendship4._id);
  expect(messages.length).toBe(3);
  compareDirectMessages(messages[0], message7);
  compareDirectMessages(messages[1], message6);
  compareDirectMessages(messages[2], message5);
  messages = await directMessageRepo.get(friendship4._id, 0);
  expect(messages.length).toBe(0);
  messages = await directMessageRepo.get(friendship4._id, -2);
  expect(messages.length).toBe(2);
  compareDirectMessages(messages[0], message7);
  compareDirectMessages(messages[1], message6);
  messages = await directMessageRepo.get(friendship4._id, 2);
  expect(messages.length).toBe(2);
  compareDirectMessages(messages[0], message7);
  compareDirectMessages(messages[1], message6);
});

test("Delete direct messages", async () => {
  const { gymRepo, userRepo, friendshipRepo, directMessageRepo } =
    repositories();
  const gym = await gymRepo.create(testGym1);
  await userRepo.create({ ...testUser1, gymId: gym._id });
  await userRepo.create({ ...testUser2, gymId: gym._id });
  await userRepo.create({ ...testUser3, gymId: gym._id });
  await userRepo.create({ ...testUser4, gymId: gym._id });
  const friendship1 = await friendshipRepo.create(testFriendship1);
  await friendshipRepo.create(testFriendship2);
  const message1 = await directMessageRepo.create({
    ...testMessage1,
    friendshipId: friendship1._id,
  });
  const message2 = await directMessageRepo.create({
    ...testMessage2,
    friendshipId: friendship1._id,
  });
  expect(await directMessageRepo.delete(message1._id)).toBeUndefined();
  let messages = await directMessageRepo.get(friendship1._id);
  expect(messages.length).toBe(1);
  compareDirectMessages(messages[0], message2);
  expect(await directMessageRepo.delete(message2._id)).toBeUndefined();
  messages = await directMessageRepo.get(friendship1._id);
  expect(messages.length).toBe(0);
  expect(await directMessageRepo.delete(message1._id)).toBe(
    kDirectMessageNotFound
  );
});
