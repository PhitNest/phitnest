import { compareUsers } from "../../../test/helpers/comparisons";
import {
  kMockAuthError,
  MockAuthDatabase,
} from "../../../test/helpers/mock-cognito";
import { kUserNotFound } from "../../common/failures";
import { IAuthEntity, IUserEntity } from "../entities";
import { login } from "./login";
import { gymRepo, userRepo } from "../repositories";
import {
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
  await gymRepo.deleteAll();
  await userRepo.deleteAll();
});

test("Login", async () => {
  rebindDatabases({
    authDatabase: new MockAuthDatabase(),
  });
  const gym = await gymRepo.create(testGym1);
  const user1 = await userRepo.create({
    ...testUser1,
    gymId: gym._id,
  });
  const user2 = await userRepo.create({
    ...testUser2,
    gymId: gym._id,
  });
  await userRepo.create({
    ...invalidUser,
    gymId: gym._id,
  });
  let result = (await login(user1.email, "password1")) as {
    session: IAuthEntity;
    user: IUserEntity;
  };
  compareUsers(result.user, user1);
  result = (await login(user2.email, "password2")) as {
    session: IAuthEntity;
    user: IUserEntity;
  };
  compareUsers(result.user, user2);
  expect(await login("invalid", "password1")).toBe(kMockAuthError);
  expect(await login("test", "password1")).toBe(kUserNotFound);
  injectDatabases();
});
