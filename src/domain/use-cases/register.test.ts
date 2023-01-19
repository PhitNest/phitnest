import mongoose from "mongoose";
import {
  compareProfilePictureUsers,
  compareUsers,
} from "../../../test/helpers/comparisons";
import {
  kMockAuthError,
  MockAuthDatabase,
} from "../../../test/helpers/mock-cognito";
import {
  kMockProfilePictureError,
  MockProfilePictureDatabase,
} from "../../../test/helpers/mock-s3";
import { kGymNotFound } from "../../common/failures";
import { IProfilePictureUserEntity, IUserEntity } from "../entities";
import { registerUser } from "./register";
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
  firstName: "firstName1",
  lastName: "lastName1",
  email: "abc1@email.com",
  password: "password1",
};

afterEach(async () => {
  await gymRepo.deleteAll();
  await userRepo.deleteAll();
});

test("Register user", async () => {
  rebindDatabases({
    authDatabase: new MockAuthDatabase(),
    profilePictureDatabase: new MockProfilePictureDatabase("cognitoId"),
  });
  const gym = await gymRepo.create(testGym1);
  expect(
    await registerUser({
      ...testUser1,
      gymId: gym._id,
    })
  ).toBe(kMockProfilePictureError);
  rebindDatabases({
    profilePictureDatabase: new MockProfilePictureDatabase(""),
  });
  const registration = (await registerUser({
    ...testUser1,
    gymId: gym._id,
  })) as IUserEntity & {
    uploadUrl: string;
  };
  expect(registration.uploadUrl).toBe("upload");
  compareUsers(registration, {
    ...testUser1,
    gymId: gym._id,
    _id: registration._id,
    cognitoId: registration.cognitoId,
    confirmed: false,
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
  injectDatabases();
});
