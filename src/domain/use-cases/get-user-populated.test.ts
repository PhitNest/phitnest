import mongoose from "mongoose";
import {
  compareGyms,
  compareProfilePictureUsers,
} from "../../../test/helpers/comparisons";
import {
  kMockProfilePictureError,
  MockProfilePictureDatabase,
} from "../../../test/helpers/mock-s3";
import { kGymNotFound, kUserNotFound } from "../../common/failures";
import { IGymEntity, IProfilePictureUserEntity } from "../entities";
import { getUserPopulated } from "./get-user-populated";
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
  cognitoId: "cognitoId1",
  firstName: "firstName1",
  lastName: "lastName1",
  email: "abc1@email.com",
};

const testUser2 = {
  cognitoId: "cognitoId2",
  firstName: "firstName2",
  lastName: "lastName2",
  email: "abc2@email.com",
};

afterEach(async () => {
  await gymRepo.deleteAll();
  await userRepo.deleteAll();
});

test("Get user populated", async () => {
  const gym = await gymRepo.create(testGym1);
  const user1 = await userRepo.create({
    ...testUser1,
    gymId: gym._id,
  });
  rebindDatabases({
    profilePictureDatabase: new MockProfilePictureDatabase(user1.cognitoId),
  });
  expect(await getUserPopulated(user1.cognitoId)).toBe(
    kMockProfilePictureError
  );
  rebindDatabases({
    profilePictureDatabase: new MockProfilePictureDatabase(""),
  });
  const populatedUser = (await getUserPopulated(
    user1.cognitoId
  )) as IProfilePictureUserEntity & {
    gym: IGymEntity;
  };
  compareProfilePictureUsers(populatedUser, {
    ...user1,
    profilePictureUrl: "get",
  });
  compareGyms(populatedUser.gym, gym);
  const user2 = await userRepo.create({
    ...testUser2,
    gymId: new mongoose.Types.ObjectId().toString(),
  });
  expect(await getUserPopulated(user2.cognitoId)).toBe(kGymNotFound);
  expect(await getUserPopulated("cognitoId3")).toBe(kUserNotFound);
  injectDatabases();
});
