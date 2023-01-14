import {
  compareDirectMessages,
  compareFriendships,
} from "../../test/helpers/comparisons";
import { IDirectMessageEntity, IPopulatedFriendshipEntity } from "../entities";
import repositories from "../repositories/injection";
import { getFriendsAndMessages } from "./friends-and-messages";

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

const testUser5 = {
  cognitoId: "cognitoId5",
  firstName: "firstName5",
  lastName: "lastName5",
  email: "abc5@email.com",
};

const testUser6 = {
  cognitoId: "cognitoId6",
  firstName: "firstName6",
  lastName: "lastName6",
  email: "abc6@email.com",
};

afterEach(async () => {
  const { gymRepo, userRepo, directMessageRepo, friendshipRepo } =
    repositories();
  await gymRepo.deleteAll();
  await userRepo.deleteAll();
  await directMessageRepo.deleteAll();
  await friendshipRepo.deleteAll();
});

type Response = {
  friendship: IPopulatedFriendshipEntity;
  message: IDirectMessageEntity;
}[];

test("Get friends and friends requests populated", async () => {
  const { gymRepo, userRepo, directMessageRepo, friendshipRepo } =
    repositories();
  const gym1 = await gymRepo.create(testGym1);
  const user1 = await userRepo.create({ ...testUser1, gymId: gym1._id });
  const user2 = await userRepo.create({ ...testUser2, gymId: gym1._id });
  const user3 = await userRepo.create({ ...testUser3, gymId: gym1._id });
  const user4 = await userRepo.create({ ...testUser4, gymId: gym1._id });
  const user5 = await userRepo.create({ ...testUser5, gymId: gym1._id });
  const user6 = await userRepo.create({ ...testUser6, gymId: gym1._id });
  let result = (await getFriendsAndMessages(user1.cognitoId)) as Response;
  expect(result.length).toBe(0);
  const friendship1 = await friendshipRepo.create([
    user1.cognitoId,
    user2.cognitoId,
  ]);
  result = (await getFriendsAndMessages(user1.cognitoId)) as Response;
  expect(result.length).toBe(1);
  compareFriendships(result[0].friendship, friendship1);
  expect(result[0].message).toBeUndefined();
  const friendship2 = await friendshipRepo.create([
    user1.cognitoId,
    user3.cognitoId,
  ]);
  const message1 = await directMessageRepo.create({
    senderCognitoId: user1.cognitoId,
    text: "hey",
    friendshipId: friendship1._id,
  });
  const message2 = await directMessageRepo.create({
    senderCognitoId: user1.cognitoId,
    text: "hey2",
    friendshipId: friendship2._id,
  });
  result = (await getFriendsAndMessages(user1.cognitoId)) as Response;
  expect(result.length).toBe(2);
  compareFriendships(result[0].friendship, friendship2);
  compareDirectMessages(result[0].message, message2);
  compareFriendships(result[1].friendship, friendship1);
  compareDirectMessages(result[1].message, message1);
  const message3 = await directMessageRepo.create({
    senderCognitoId: user2.cognitoId,
    text: "hey3",
    friendshipId: friendship1._id,
  });
  result = (await getFriendsAndMessages(user1.cognitoId)) as Response;
  expect(result.length).toBe(2);
  compareFriendships(result[0].friendship, friendship1);
  compareDirectMessages(result[0].message, message3);
  compareFriendships(result[1].friendship, friendship2);
  compareDirectMessages(result[1].message, message2);
  const friendship3 = await friendshipRepo.create([
    user1.cognitoId,
    user4.cognitoId,
  ]);
  result = (await getFriendsAndMessages(user1.cognitoId)) as Response;
  expect(result.length).toBe(3);
  compareFriendships(result[0].friendship, friendship3);
  expect(result[0].message).toBeUndefined();
  compareFriendships(result[1].friendship, friendship1);
  compareDirectMessages(result[1].message, message3);
  compareFriendships(result[2].friendship, friendship2);
  compareDirectMessages(result[2].message, message2);
  const message4 = await directMessageRepo.create({
    senderCognitoId: user1.cognitoId,
    text: "hey4",
    friendshipId: friendship2._id,
  });
  const friendship4 = await friendshipRepo.create([
    user1.cognitoId,
    user5.cognitoId,
  ]);
  result = (await getFriendsAndMessages(user1.cognitoId)) as Response;
  expect(result.length).toBe(4);
  compareFriendships(result[0].friendship, friendship4);
  expect(result[0].message).toBeUndefined();
  compareFriendships(result[1].friendship, friendship2);
  compareDirectMessages(result[1].message, message4);
  compareFriendships(result[2].friendship, friendship3);
  expect(result[2].message).toBeUndefined();
  compareFriendships(result[3].friendship, friendship1);
  compareDirectMessages(result[3].message, message3);
  const friendship5 = await friendshipRepo.create([
    user1.cognitoId,
    user6.cognitoId,
  ]);
  result = (await getFriendsAndMessages(user1.cognitoId)) as Response;
  expect(result.length).toBe(5);
  compareFriendships(result[0].friendship, friendship5);
  expect(result[0].message).toBeUndefined();
  compareFriendships(result[1].friendship, friendship4);
  expect(result[1].message).toBeUndefined();
  compareFriendships(result[2].friendship, friendship2);
  compareDirectMessages(result[2].message, message4);
  compareFriendships(result[3].friendship, friendship3);
  expect(result[3].message).toBeUndefined();
  compareFriendships(result[4].friendship, friendship1);
  compareDirectMessages(result[4].message, message3);
});
