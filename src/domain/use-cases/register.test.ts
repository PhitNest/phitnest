import mongoose from "mongoose";
import { compareUsers } from "../../../test/helpers/comparisons";
import {
  kMockAuthError,
  MockAuthDatabase,
} from "../../../test/helpers/mock-cognito";
import {
  kMockProfilePictureError,
  MockProfilePictureDatabase,
} from "../../../test/helpers/mock-s3";
import { kGymNotFound } from "../../common/failures";
import { IUserEntity } from "../entities";
import { registerUser } from "./register";
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
  firstName: "firstName1",
  lastName: "lastName1",
  email: "abc1@email.com",
  password: "password1",
};

afterEach(async () => {
  await databases().gymDatabase.deleteAll();
  await databases().userDatabase.deleteAll();
});

test("Register user", async () => {
  rebindDatabases({
    authDatabase: new MockAuthDatabase(),
    profilePictureDatabase: new MockProfilePictureDatabase("cognitoId"),
  });
  const gym = await databases().gymDatabase.create(testGym1);
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
  })) as {
    user: IUserEntity;
    uploadUrl: string;
  };
  expect(registration.uploadUrl).toBe("upload");
  compareUsers(registration.user, {
    ...testUser1,
    gymId: gym._id,
    _id: registration.user._id,
    cognitoId: registration.user.cognitoId,
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
