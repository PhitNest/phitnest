import { compareProfilePictureUsers } from "../../../test/helpers/comparisons";
import {
  kMockAuthError,
  MockAuthDatabase,
} from "../../../test/helpers/mock-cognito";
import {
  kMockProfilePictureError,
  MockProfilePictureDatabase,
} from "../../../test/helpers/mock-s3";
import { kUserNotFound } from "../../common/failures";
import { Failure } from "../../common/types";
import { MongoUserDatabase } from "../../data/data-sources/databases/implementations";
import { IProfilePictureUserEntity } from "../entities";
import { confirmRegister } from "./confirm-register";
import databases, {
  injectDatabases,
  rebindDatabases,
} from "../../data/data-sources/injection";

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
  password: "password1",
};

const cognitoFailingUser = {
  cognitoId: "cognitoId2",
  firstName: "firstName1",
  lastName: "lastName1",
  email: "invalid",
  password: "password1",
};

const failingUser = {
  cognitoId: "invalidSetConfirmed",
  firstName: "firstName1",
  lastName: "lastName1",
  email: "abc2@email.com",
};

const kMockFailingUserRepo = new Failure(
  "MockFailingUserRepo",
  "Mock failing user repo"
);

class FailingUserDatabase extends MongoUserDatabase {
  async setConfirmed(cognitoId: string) {
    if (cognitoId === "invalidSetConfirmed") {
      return kMockFailingUserRepo;
    } else {
      return super.setConfirmed(cognitoId);
    }
  }
}

afterEach(async () => {
  await databases().gymDatabase.deleteAll();
  await databases().userDatabase.deleteAll();
});

test("Confirm registration", async () => {
  rebindDatabases({
    authDatabase: new MockAuthDatabase(),
    userDatabase: new FailingUserDatabase(),
    profilePictureDatabase: new MockProfilePictureDatabase(testUser1.cognitoId),
  });
  const gym = await databases().gymDatabase.create(testGym1);
  const user1 = await databases().userDatabase.create({
    ...testUser1,
    gymId: gym._id,
  });
  const user2 = await databases().userDatabase.create({
    ...cognitoFailingUser,
    gymId: gym._id,
  });
  const user3 = await databases().userDatabase.create({
    ...failingUser,
    gymId: gym._id,
  });
  expect(await confirmRegister(testUser1.email, "123456")).toBe(
    kMockProfilePictureError
  );
  rebindDatabases({
    profilePictureDatabase: new MockProfilePictureDatabase(""),
  });
  const result = (await confirmRegister(
    testUser1.email,
    "123456"
  )) as IProfilePictureUserEntity;
  user1.confirmed = true;
  compareProfilePictureUsers(result, { ...user1, profilePictureUrl: "get" });
  expect(await confirmRegister("invalidUser", "123456")).toBe(kUserNotFound);
  expect(await confirmRegister(user2.email, "123456")).toBe(kMockAuthError);
  expect(await confirmRegister(user3.email, "123456")).toBe(
    kMockFailingUserRepo
  );
  injectDatabases();
});
