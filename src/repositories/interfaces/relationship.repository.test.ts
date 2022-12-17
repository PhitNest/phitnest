import { comparePublicUserData } from "../../../test/helpers/comparisons";
import { dependencies, Repositories } from "../../common/dependency-injection";
import { IGymEntity, IUserEntity, LocationEntity } from "../../entities";
import { IGymRepository, IRelationshipRepository, IUserRepository } from ".";

const testGym1 = {
  name: "Test Gym",
  address: {
    street: "123 Test Street",
    city: "Test City",
    state: "Test State",
    zipCode: "12345",
  },
  location: new LocationEntity(-122.4194, 37.7749),
};

const testGym2 = {
  name: "Test Gym 2",
  address: {
    street: "256 Test Street",
    city: "Test City",
    state: "Test State",
    zipCode: "12344",
  },
  location: new LocationEntity(122.4194, 37.7749),
};

const testUser1 = {
  cognitoId: "id1",
  gymId: "",
  email: "testEmail@gmail.com",
  firstName: "testFirstName",
  lastName: "testLastName",
};

const testUser2 = {
  cognitoId: "id2",
  gymId: "",
  email: "testEmail2@gmail.com",
  firstName: "testFirstName2",
  lastName: "testLastName2",
};

const testUser3 = {
  cognitoId: "id3",
  gymId: "",
  email: "testEmail3@gmail.com",
  firstName: "testFirstName3",
  lastName: "testLastName3",
};

const testUser4 = {
  cognitoId: "id4",
  gymId: "",
  email: "testEmail4@gmail.com",
  firstName: "testFirstName4",
  lastName: "testLastName4",
};

let gym1: IGymEntity;
let gym2: IGymEntity;
let user1: IUserEntity;
let user2: IUserEntity;
let user3: IUserEntity;
let user4: IUserEntity;

let relationshipRepo: IRelationshipRepository;
let gymRepo: IGymRepository;
let userRepo: IUserRepository;

beforeAll(async () => {
  relationshipRepo = dependencies.get(Repositories.relationship);
  gymRepo = dependencies.get(Repositories.gym);
  userRepo = dependencies.get(Repositories.user);
  gym1 = await gymRepo.create(testGym1);
  gym2 = await gymRepo.create(testGym2);
  testUser1.gymId = gym1._id;
  user1 = await userRepo.create(testUser1);
  testUser2.gymId = gym1._id;
  user2 = await userRepo.create(testUser2);
  testUser3.gymId = gym1._id;
  user3 = await userRepo.create(testUser3);
  testUser4.gymId = gym2._id;
  user4 = await userRepo.create(testUser4);
});

test("Sending and denying friend requests, and blocking", async () => {
  expect(gym1).toBeDefined();
  expect(gym2).toBeDefined();
  expect(user1).toBeDefined();
  expect(user2).toBeDefined();
  expect(user3).toBeDefined();
  expect(user4).toBeDefined();
  await relationshipRepo.createRequest(user1.cognitoId, user2.cognitoId);
  let sentRequests = await relationshipRepo.getPendingOutboundRequests(
    user1.cognitoId
  );
  expect(sentRequests.length).toBe(1);
  comparePublicUserData(sentRequests[0], user2);
  let receivedRequests = await relationshipRepo.getPendingInboundRequests(
    user1.cognitoId
  );
  expect(receivedRequests.length).toBe(0);
  sentRequests = await relationshipRepo.getPendingOutboundRequests(
    user2.cognitoId
  );
  expect(sentRequests.length).toBe(0);
  receivedRequests = await relationshipRepo.getPendingInboundRequests(
    user2.cognitoId
  );
  expect(receivedRequests.length).toBe(1);
  comparePublicUserData(receivedRequests[0], user1);
  let friends = await relationshipRepo.getFriends(user1.cognitoId);
  expect(friends.length).toBe(0);
  friends = await relationshipRepo.getFriends(user2.cognitoId);
  expect(friends.length).toBe(0);
  expect(
    await relationshipRepo.isFriend(user1.cognitoId, user2.cognitoId)
  ).toBeFalsy();
  await relationshipRepo.createDeny(user2.cognitoId, user1.cognitoId);
  sentRequests = await relationshipRepo.getPendingOutboundRequests(
    user1.cognitoId
  );
  receivedRequests = await relationshipRepo.getPendingInboundRequests(
    user1.cognitoId
  );
  expect(receivedRequests.length).toBe(0);
  expect(sentRequests.length).toBe(0);
  await relationshipRepo.createDeny(user1.cognitoId, user2.cognitoId);
  sentRequests = await relationshipRepo.getPendingOutboundRequests(
    user1.cognitoId
  );
  receivedRequests = await relationshipRepo.getPendingInboundRequests(
    user1.cognitoId
  );
  expect(receivedRequests.length).toBe(0);
  expect(sentRequests.length).toBe(0);
  friends = await relationshipRepo.getFriends(user1.cognitoId);
  expect(friends.length).toBe(0);
  await relationshipRepo.createRequest(user1.cognitoId, user2.cognitoId);
  await relationshipRepo.createRequest(user2.cognitoId, user1.cognitoId);
  sentRequests = await relationshipRepo.getPendingOutboundRequests(
    user1.cognitoId
  );
  receivedRequests = await relationshipRepo.getPendingInboundRequests(
    user1.cognitoId
  );
  expect(receivedRequests.length).toBe(0);
  expect(sentRequests.length).toBe(0);
  friends = await relationshipRepo.getFriends(user1.cognitoId);
  expect(friends.length).toBe(1);
  expect(
    await relationshipRepo.isFriend(user1.cognitoId, user2.cognitoId)
  ).toBeTruthy();
  comparePublicUserData(friends[0], user2);
  await relationshipRepo.createBlock(user1.cognitoId, user2.cognitoId);
  sentRequests = await relationshipRepo.getPendingOutboundRequests(
    user1.cognitoId
  );
  receivedRequests = await relationshipRepo.getPendingInboundRequests(
    user1.cognitoId
  );
  expect(receivedRequests.length).toBe(0);
  expect(sentRequests.length).toBe(0);
  sentRequests = await relationshipRepo.getPendingOutboundRequests(
    user2.cognitoId
  );
  receivedRequests = await relationshipRepo.getPendingInboundRequests(
    user2.cognitoId
  );
  expect(receivedRequests.length).toBe(0);
  expect(sentRequests.length).toBe(0);
  friends = await relationshipRepo.getFriends(user2.cognitoId);
  expect(friends.length).toBe(0);
  friends = await relationshipRepo.getFriends(user1.cognitoId);
  expect(friends.length).toBe(0);
  await relationshipRepo.deleteBlock(user1.cognitoId, user2.cognitoId);
  sentRequests = await relationshipRepo.getPendingOutboundRequests(
    user1.cognitoId
  );
  receivedRequests = await relationshipRepo.getPendingInboundRequests(
    user1.cognitoId
  );
  expect(receivedRequests.length).toBe(1);
  expect(sentRequests.length).toBe(0);
  sentRequests = await relationshipRepo.getPendingOutboundRequests(
    user2.cognitoId
  );
  receivedRequests = await relationshipRepo.getPendingInboundRequests(
    user2.cognitoId
  );
  expect(receivedRequests.length).toBe(0);
  expect(sentRequests.length).toBe(1);
  comparePublicUserData(sentRequests[0], user1);
  friends = await relationshipRepo.getFriends(user2.cognitoId);
  expect(friends.length).toBe(0);
  friends = await relationshipRepo.getFriends(user1.cognitoId);
  expect(friends.length).toBe(0);
});
