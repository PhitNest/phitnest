import mongoose from "mongoose";
import { compareProfilePictureUsers } from "../../test/helpers/comparisons";
import {
  kMockAuthError,
  MockAuthRepository,
} from "../../test/helpers/mock-cognito";
import {
  kMockProfilePictureError,
  MockProfilePictureRepo,
} from "../../test/helpers/mock-s3";
import { kGymNotFound } from "../common/failures";
import { IProfilePictureUserEntity } from "../entities";
import repositories, {
  injectRepositories,
  rebindRepositories,
} from "../repositories/injection";
import { registerUser } from "./register";

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
  firstName: "firstName1",
  lastName: "lastName1",
  email: "abc1@email.com",
  password: "password1",
};

afterEach(async () => {
  const { gymRepo, userRepo } = repositories();
  await gymRepo.deleteAll();
  await userRepo.deleteAll();
});

test("Register user", async () => {
  rebindRepositories({
    authRepo: new MockAuthRepository(),
    profilePictureRepo: new MockProfilePictureRepo("cognitoId"),
  });
  const { gymRepo } = repositories();
  const gym = await gymRepo.create(testGym1);
  expect(
    await registerUser({
      ...testUser1,
      gymId: gym._id,
    })
  ).toBe(kMockProfilePictureError);
  rebindRepositories({
    profilePictureRepo: new MockProfilePictureRepo(""),
  });
  const registration = (await registerUser({
    ...testUser1,
    gymId: gym._id,
  })) as IProfilePictureUserEntity;
  compareProfilePictureUsers(registration, {
    ...testUser1,
    gymId: gym._id,
    _id: registration._id,
    cognitoId: registration.cognitoId,
    confirmed: false,
    profilePictureUrl: "upload",
  });
  expect(
    await registerUser({
      ...testUser1,
      gymId: new mongoose.Types.ObjectId().toString(),
    })
  ).toEqual(kGymNotFound);
  expect(
    await registerUser({
      ...testUser1,
      gymId: gym._id,
      email: "invalid",
    })
  ).toBe(kMockAuthError);
  injectRepositories();
});
