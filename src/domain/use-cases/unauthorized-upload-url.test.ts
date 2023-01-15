import {
  kMockProfilePictureError,
  MockProfilePictureDatabase,
} from "../../../test/helpers/mock-s3";
import {
  kInvalidCognitoId,
  kUserAlreadyConfirmed,
  kUserNotFound,
} from "../../common/failures";
import { rebindDatabases } from "../../data/data-sources/injection";
import { userRepo, gymRepo } from "../repositories";
import { unauthorizedProfilePictureUploadUrl } from "./unauthorized-upload-url";

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

afterEach(async () => {
  await gymRepo.deleteAll();
  await userRepo.deleteAll();
});

test("Unauthorized get upload url", async () => {
  const gym1 = await gymRepo.create(testGym1);
  const user1 = await userRepo.create({ ...testUser1, gymId: gym1._id });
  rebindDatabases({
    profilePictureDatabase: new MockProfilePictureDatabase(user1.cognitoId),
  });
  expect(
    await unauthorizedProfilePictureUploadUrl(testUser1.email, user1.cognitoId)
  ).toBe(kMockProfilePictureError);
  rebindDatabases({
    profilePictureDatabase: new MockProfilePictureDatabase(""),
  });
  expect(
    await unauthorizedProfilePictureUploadUrl("fakeEmail", user1.cognitoId)
  ).toBe(kUserNotFound);
  expect(
    await unauthorizedProfilePictureUploadUrl(testUser1.email, "fakeCognitoId")
  ).toBe(kInvalidCognitoId);
  const result = (await unauthorizedProfilePictureUploadUrl(
    testUser1.email,
    user1.cognitoId
  )) as {
    url: string;
  };
  expect(result.url).toEqual("upload");
  await userRepo.setConfirmed(user1.cognitoId);
  expect(
    await unauthorizedProfilePictureUploadUrl(testUser1.email, user1.cognitoId)
  ).toBe(kUserAlreadyConfirmed);
});
