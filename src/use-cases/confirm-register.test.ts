import { compareUsers } from "../../test/helpers/comparisons";
import { MockAuthRepository } from "../../test/helpers/mock-cognito";
import { kUserNotFound } from "../common/failures";
import { IUserEntity } from "../entities";
import { MongoUserRepository } from "../repositories/implementations";
import repositories, {
  injectRepositories,
  rebindRepositories,
} from "../repositories/injection";
import { confirmRegister } from "./confirm-register";

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

const testUser2 = {
  cognitoId: "invalidSetConfirmed",
  firstName: "firstName1",
  lastName: "lastName1",
  email: "abc2@email.com",
  password: "password1",
};

class MockUserRepo extends MongoUserRepository {
  async setConfirmed(email: string) {
    if (email == "invalidSetConfirmed") {
      return kUserNotFound;
    } else {
      return super.setConfirmed(email);
    }
  }
}

afterEach(async () => {
  const { gymRepo, userRepo } = repositories();
  await gymRepo.deleteAll();
  await userRepo.deleteAll();
});

test("Confirm registration", async () => {
  rebindRepositories({
    authRepo: new MockAuthRepository(),
    userRepo: new MockUserRepo(),
  });
  const { gymRepo, userRepo } = repositories();
  const gym = await gymRepo.create(testGym1);
  const user1 = await userRepo.create({ ...testUser1, gymId: gym._id });
  const user2 = await userRepo.create({ ...testUser2, gymId: gym._id });
  const result = (await confirmRegister(
    testUser1.email,
    "123456"
  )) as IUserEntity;
  user1.confirmed = true;
  compareUsers(result, user1);
  expect(await confirmRegister("invalid", "123456")).toBe(kUserNotFound);
  expect(await confirmRegister("test", "123456")).toBe(kUserNotFound);
  expect(await confirmRegister(user2.email, "123456")).toBe(kUserNotFound);
  injectRepositories();
});
