import { compareDirectMessages } from "../../test/helpers/comparisons";
import { kFriendshipNotFound } from "../common/failures";
import { Failure } from "../common/types";
import { IDirectMessageEntity } from "../entities";
import repositories from "../repositories/injection";
import { sendDirectMessage } from "./send-direct-message";

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
  const { gymRepo, userRepo, directMessageRepo, friendshipRepo } =
    repositories();
  await gymRepo.deleteAll();
  await userRepo.deleteAll();
  await directMessageRepo.deleteAll();
  await friendshipRepo.deleteAll();
});

test("Send direct message", async () => {
  const { gymRepo, userRepo, friendshipRepo } = repositories();
  const gym1 = await gymRepo.create(testGym1);
  const user1 = await userRepo.create({ ...testUser1, gymId: gym1._id });
  const user2 = await userRepo.create({ ...testUser2, gymId: gym1._id });
  const user3 = await userRepo.create({ ...testUser3, gymId: gym1._id });
  let failure = await sendDirectMessage(
    user1.cognitoId,
    user2.cognitoId,
    "hey"
  );
  expect(failure).toBe(kFriendshipNotFound);
  const friendship1 = await friendshipRepo.create([
    user1.cognitoId,
    user2.cognitoId,
  ]);
  const directMessage = (await sendDirectMessage(
    user1.cognitoId,
    user2.cognitoId,
    "hey"
  )) as IDirectMessageEntity;
  compareDirectMessages(
    {
      _id: directMessage._id,
      createdAt: directMessage.createdAt,
      senderCognitoId: user1.cognitoId,
      friendshipId: friendship1._id,
      text: "hey",
    },
    directMessage
  );
  failure = (await sendDirectMessage(
    user3.cognitoId,
    user1.cognitoId,
    "hey"
  )) as Failure;
  expect(failure).toBe(kFriendshipNotFound);
  const friendship2 = await friendshipRepo.create([
    user3.cognitoId,
    user1.cognitoId,
  ]);
  const directMessage2 = (await sendDirectMessage(
    user3.cognitoId,
    user1.cognitoId,
    "hey2"
  )) as IDirectMessageEntity;
  compareDirectMessages(
    {
      _id: directMessage2._id,
      createdAt: directMessage2.createdAt,
      senderCognitoId: user3.cognitoId,
      friendshipId: friendship2._id,
      text: "hey2",
    },
    directMessage2
  );
  const directMessage3 = (await sendDirectMessage(
    user1.cognitoId,
    user3.cognitoId,
    "hey3"
  )) as IDirectMessageEntity;
  compareDirectMessages(
    {
      _id: directMessage3._id,
      createdAt: directMessage3.createdAt,
      senderCognitoId: user1.cognitoId,
      friendshipId: friendship2._id,
      text: "hey3",
    },
    directMessage3
  );
});
