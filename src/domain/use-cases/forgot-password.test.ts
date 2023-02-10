import {
  kMockAuthError,
  MockAuthDatabase,
} from "../../../test/helpers/mock-cognito";
import { kUserNotConfirmed, kUserNotFound } from "../../common/failures";
import databases, {
  injectDatabases,
  rebindDatabases,
} from "../../data/data-sources/injection";
import { forgotPassword } from "./forgot-password";

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
  email: "invalid",
};

afterEach(async () => {
  await databases().gymDatabase.deleteAll();
  await databases().userDatabase.deleteAll();
});

test("Forgot password", async () => {
  rebindDatabases({
    authDatabase: new MockAuthDatabase(),
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
  expect(await forgotPassword(testUser1.email)).toBe(kUserNotConfirmed);
  expect(await forgotPassword(testUser2.email)).toBe(kUserNotConfirmed);
  expect(await forgotPassword("")).toBe(kUserNotFound);
  await databases().userDatabase.setConfirmed(user1.cognitoId);
  await databases().userDatabase.setConfirmed(user2.cognitoId);
  expect(await forgotPassword(testUser1.email)).toBeUndefined();
  expect(await forgotPassword(testUser2.email)).toBe(kMockAuthError);
  injectDatabases();
});
