import { compareProfilePictureUsers } from "../../test/helpers/comparisons";
import {
  kMockAuthError,
  MockAuthRepository,
} from "../../test/helpers/mock-cognito";
import {
  kMockProfilePictureError,
  MockProfilePictureRepo,
} from "../../test/helpers/mock-s3";
import { kUserNotFound } from "../common/failures";
import { Failure } from "../common/types";
import { IProfilePictureUserEntity } from "../entities";
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

class FailingUserRepo extends MongoUserRepository {
  async setConfirmed(cognitoId: string) {
    if (cognitoId === "invalidSetConfirmed") {
      return kMockFailingUserRepo;
    } else {
      return super.setConfirmed(cognitoId);
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
    userRepo: new FailingUserRepo(),
    profilePictureRepo: new MockProfilePictureRepo(testUser1.cognitoId),
  });
  const { gymRepo, userRepo } = repositories();
  const gym = await gymRepo.create(testGym1);
  const user1 = await userRepo.create({ ...testUser1, gymId: gym._id });
  const user2 = await userRepo.create({
    ...cognitoFailingUser,
    gymId: gym._id,
  });
  const user3 = await userRepo.create({
    ...failingUser,
    gymId: gym._id,
  });
  expect(await confirmRegister(testUser1.email, "123456")).toBe(
    kMockProfilePictureError
  );
  rebindRepositories({
    profilePictureRepo: new MockProfilePictureRepo(""),
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
  injectRepositories();
});
