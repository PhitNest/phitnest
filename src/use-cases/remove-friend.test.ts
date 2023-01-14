import { compareFriendRequests } from "../../test/helpers/comparisons";
import { Failure } from "../common/types";
import { IFriendRequestEntity } from "../entities";
import { MongoFriendshipRepository } from "../repositories/implementations";
import repositories, { rebindRepositories } from "../repositories/injection";
import { removeFriend } from "./remove-friend";

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

const kFailedFriendshipDeletion = new Failure(
  "MockFriendRequestFailure",
  "Failed to delete friendship"
);

class FailingFriendshipRepo extends MongoFriendshipRepository {
  async delete(cognitoIds: [string, string]) {
    if (cognitoIds[0] === "invalid") {
      return kFailedFriendshipDeletion;
    } else {
      return super.delete(cognitoIds);
    }
  }
}

test("Remove friend", async () => {
  rebindRepositories({
    friendshipRepo: new FailingFriendshipRepo(),
  });
  const { userRepo, friendshipRepo, gymRepo, friendRequestRepo } =
    repositories();
  const gym = await gymRepo.create(testGym1);
  const user1 = await userRepo.create({ ...testUser1, gymId: gym._id });
  const user2 = await userRepo.create({ ...testUser2, gymId: gym._id });
  await friendshipRepo.create([user1.cognitoId, user2.cognitoId]);
  expect(await removeFriend(user1.cognitoId, user2.cognitoId)).toBeUndefined();
  const friendRequest = (await friendRequestRepo.getByCognitoIds(
    user2.cognitoId,
    user1.cognitoId
  )) as IFriendRequestEntity;
  compareFriendRequests(friendRequest, {
    fromCognitoId: user2.cognitoId,
    toCognitoId: user1.cognitoId,
    createdAt: friendRequest.createdAt,
    denied: false,
    _id: friendRequest._id,
  });
  expect(await removeFriend("invalid", user2.cognitoId)).toBe(
    kFailedFriendshipDeletion
  );
});
