import { compareUsers } from "../../../test/helpers/comparisons";
import {
  kMockAuthError,
  MockAuthDatabase,
} from "../../../test/helpers/mock-cognito";
import { kUserNotFound } from "../../common/failures";
import { IAuthEntity, IProfilePictureUserEntity } from "../entities";
import { login } from "./login";
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

const testUser1 = {
  cognitoId: "testCognito1",
  firstName: "firstName1",
  lastName: "lastName1",
  email: "abc1@email.com",
};

const testUser2 = {
  cognitoId: "testCognito2",
  firstName: "firstName2",
  lastName: "lastName2",
  email: "abc2@email.com",
};

const invalidUser = {
  cognitoId: "invalid",
  firstName: "firstName1",
  lastName: "lastName1",
  email: "invalid",
};

afterEach(async () => {
  await databases().gymDatabase.deleteAll();
  await databases().userDatabase.deleteAll();
});

test("Login", async () => {
  rebindDatabases({
    authDatabase: new MockAuthDatabase(),
    profilePictureDatabase: new MockProfilePictureDatabase("invalid"),
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
  await databases().userDatabase.create({
    ...invalidUser,
    gymId: gym._id,
  });
  let result = (await login(user1.email, "password1")) as IAuthEntity & {
    user: IProfilePictureUserEntity;
  };
  compareUsers(result.user, user1);
  result = (await login(user2.email, "password2")) as IAuthEntity & {
    user: IProfilePictureUserEntity;
  };
  compareUsers(result.user, user2);
  expect(await login("invalid", "password1")).toBe(kMockAuthError);
  expect(await login("test", "password1")).toBe(kUserNotFound);
  injectDatabases();
});
