import { compareUsers } from "../../test/helpers/comparisons";
import { MockAuthRepository } from "../../test/helpers/mock-cognito";
import { kUserNotFound } from "../common/failures";
import { IAuthEntity, IUserEntity } from "../entities";
import repositories, {
  injectRepositories,
  rebindRepositories,
} from "../repositories/injection";
import { login } from "./login";

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

afterEach(async () => {
  const { gymRepo, userRepo } = repositories();
  await gymRepo.deleteAll();
  await userRepo.deleteAll();
});

test("Login", async () => {
  rebindRepositories({
    authRepo: new MockAuthRepository(),
  });
  const { gymRepo, userRepo } = repositories();
  const gym = await gymRepo.create(testGym1);
  const user1 = await userRepo.create({
    ...testUser1,
    gymId: gym._id,
  });
  const user2 = await userRepo.create({
    ...testUser2,
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
  expect(await login("invalid", "password1")).toBe(kUserNotFound);
  expect(await login("test", "password1")).toBe(kUserNotFound);
  injectRepositories();
});
