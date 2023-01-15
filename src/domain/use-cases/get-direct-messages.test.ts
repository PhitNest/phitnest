import { compareDirectMessages } from "../../../test/helpers/comparisons";
import { kFriendshipNotFound } from "../../common/failures";
import { Failure } from "../../common/types";
import { IDirectMessageEntity } from "../entities";
import { getDirectMessages } from "./get-direct-messages";
import {
  gymRepo,
  userRepo,
  friendshipRepo,
  directMessageRepo,
} from "../repositories";

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

afterEach(async () => {
  await gymRepo.deleteAll();
  await userRepo.deleteAll();
  await friendshipRepo.deleteAll();
  await directMessageRepo.deleteAll();
});

test("Get direct messages", async () => {
  const gym1 = await gymRepo.create(testGym1);
  const user1 = await userRepo.create({ ...testUser1, gymId: gym1._id });
  const user2 = await userRepo.create({ ...testUser2, gymId: gym1._id });
  const user3 = await userRepo.create({ ...testUser3, gymId: gym1._id });
  const friendship1 = await friendshipRepo.create([
    user1.cognitoId,
    user2.cognitoId,
  ]);
  const friendship2 = await friendshipRepo.create([
    user1.cognitoId,
    user3.cognitoId,
  ]);
  const directMessage1 = await directMessageRepo.create({
    friendshipId: friendship1._id,
    senderCognitoId: user1.cognitoId,
    text: "message1",
  });
  const directMessage2 = await directMessageRepo.create({
    friendshipId: friendship1._id,
    senderCognitoId: user2.cognitoId,
    text: "message2",
  });
  const directMessage3 = await directMessageRepo.create({
    friendshipId: friendship2._id,
    senderCognitoId: user1.cognitoId,
    text: "message3",
  });
  const directMessage4 = await directMessageRepo.create({
    friendshipId: friendship2._id,
    senderCognitoId: user3.cognitoId,
    text: "message4",
  });
  const directMessage5 = await directMessageRepo.create({
    friendshipId: friendship2._id,
    senderCognitoId: user1.cognitoId,
    text: "message5",
  });
  const directMessage6 = await directMessageRepo.create({
    friendshipId: friendship2._id,
    senderCognitoId: user3.cognitoId,
    text: "message6",
  });
  let directMessages = (await getDirectMessages([
    user1.cognitoId,
    user2.cognitoId,
  ])) as IDirectMessageEntity[];
  expect(directMessages.length).toBe(2);
  compareDirectMessages(directMessages[0], directMessage2);
  compareDirectMessages(directMessages[1], directMessage1);
  directMessages = (await getDirectMessages([
    user1.cognitoId,
    user3.cognitoId,
  ])) as IDirectMessageEntity[];
  expect(directMessages.length).toBe(4);
  compareDirectMessages(directMessages[0], directMessage6);
  compareDirectMessages(directMessages[1], directMessage5);
  compareDirectMessages(directMessages[2], directMessage4);
  compareDirectMessages(directMessages[3], directMessage3);
  const failure = (await getDirectMessages([
    user1.cognitoId,
    "fakeId",
  ])) as Failure;
  expect(failure).toBe(kFriendshipNotFound);
});
