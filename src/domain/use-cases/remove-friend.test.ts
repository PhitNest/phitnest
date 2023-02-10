import { compareFriendRequests } from "../../../test/helpers/comparisons";
import { Failure } from "../../common/types";
import { MongoFriendshipDatabase } from "../../data/data-sources/databases/implementations";
import databases, { rebindDatabases } from "../../data/data-sources/injection";
import { IFriendRequestEntity } from "../entities";
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

class FailingFriendshipDatabase extends MongoFriendshipDatabase {
  async delete(cognitoIds: [string, string]) {
    if (cognitoIds[0] === "invalid") {
      return kFailedFriendshipDeletion;
    } else {
      return super.delete(cognitoIds);
    }
  }
}

test("Remove friend", async () => {
  rebindDatabases({
    friendshipDatabase: new FailingFriendshipDatabase(),
  });
  const gym = await databases().gymDatabase.create(testGym1);
  const user1 = await databases().userDatabase.create({
    ...testUser1,
    gymId: gym._id,
  });
  const user2 = await databases().userDatabase.create({
    ...testUser2,
    gymId: gym._id,
  });
  await databases().friendshipDatabase.create([
    user1.cognitoId,
    user2.cognitoId,
  ]);
  expect(await removeFriend(user1.cognitoId, user2.cognitoId)).toBeUndefined();
  const friendRequest =
    (await databases().friendRequestDatabase.getByCognitoIds(
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
