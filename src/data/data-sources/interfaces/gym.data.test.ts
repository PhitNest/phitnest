import mongoose from "mongoose";
import { compareGyms } from "../../../../test/helpers/comparisons";
import { kGymNotFound } from "../../../common/failures";
import { IGymEntity } from "../../../domain/entities";
import dataSources from "../injection";

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

const testGym2 = {
  name: "testGym2",
  address: {
    street: "testStreet2",
    city: "testCity2",
    state: "testState2",
    zipCode: "testZipCode2",
  },
  location: {
    type: "Point",
    coordinates: [-80.4138162, 37.2294115] as [number, number],
  },
};

const testGym3 = {
  name: "testGym3",
  address: {
    street: "testStreet3",
    city: "testCity3",
    state: "testState3",
    zipCode: "testZipCode3",
  },
  location: {
    type: "Point",
    coordinates: [-77, 36.8497312] as [number, number],
  },
};

const queryLocation = {
  type: "Point",
  coordinates: [-76.99618967933559, 36.8497312] as [number, number],
};

const testUser1 = {
  cognitoId: "testCognitoId1",
  firstName: "firstName1",
  lastName: "lastName1",
  email: "email1@abc.com",
};

const testUser2 = {
  cognitoId: "testCognitoId2",
  firstName: "firstName2",
  lastName: "lastName2",
  email: "email2@abc.com",
};

const testUser3 = {
  cognitoId: "testCognitoId3",
  firstName: "firstName3",
  lastName: "lastName3",
  email: "email3@abc.com",
};

afterEach(async () => {
  const { gymDatabase, userDatabase } = dataSources();
  await gymDatabase.deleteAll();
  await userDatabase.deleteAll();
});

test("Create a gym", async () => {
  const { gymDatabase } = dataSources();
  const gym1 = await gymDatabase.create(testGym1);
  compareGyms(gym1, {
    ...testGym1,
    _id: gym1._id,
  });
  const gym2 = await gymDatabase.create(testGym2);
  compareGyms(gym2, {
    ...testGym2,
    _id: gym2._id,
  });
});

test("Get by id", async () => {
  const { gymDatabase } = dataSources();
  const gym1 = await gymDatabase.create(testGym1);
  const gym2 = await gymDatabase.create(testGym2);
  const gym3 = await gymDatabase.create(testGym3);
  let gym = (await gymDatabase.get(gym1._id)) as IGymEntity;
  compareGyms(gym, gym1);
  gym = (await gymDatabase.get(gym2._id)) as IGymEntity;
  compareGyms(gym, gym2);
  gym = (await gymDatabase.get(gym3._id)) as IGymEntity;
  compareGyms(gym, gym3);
  const failure = await gymDatabase.get(
    new mongoose.Types.ObjectId().toString()
  );
  expect(failure).toBe(kGymNotFound);
});

test("Get nearest gyms", async () => {
  const { gymDatabase } = dataSources();
  const gym1 = await gymDatabase.create(testGym1);
  const gym2 = await gymDatabase.create(testGym2);
  const gym3 = await gymDatabase.create(testGym3);
  await expect(
    gymDatabase.getNearest(queryLocation, -1)
  ).rejects.toThrowError();
  let gyms = await gymDatabase.getNearest(queryLocation, 0);
  expect(gyms.length).toBe(0);
  gyms = await gymDatabase.getNearest(queryLocation, 1000);
  expect(gyms.length).toBe(1);
  compareGyms(gyms[0], gym3);
  gyms = await gymDatabase.getNearest(queryLocation, 1000, -1);
  expect(gyms.length).toBe(1);
  compareGyms(gyms[0], gym3);
  gyms = await gymDatabase.getNearest(queryLocation, 1000, 0);
  expect(gyms.length).toBe(0);
  gyms = await gymDatabase.getNearest(queryLocation, 1000, 2);
  expect(gyms.length).toBe(1);
  compareGyms(gyms[0], gym3);
  gyms = await gymDatabase.getNearest(queryLocation, 100000);
  expect(gyms.length).toBe(2);
  compareGyms(gyms[0], gym3);
  compareGyms(gyms[1], gym1);
  gyms = await gymDatabase.getNearest(queryLocation, 1000000);
  expect(gyms.length).toBe(3);
  compareGyms(gyms[0], gym3);
  compareGyms(gyms[1], gym1);
  compareGyms(gyms[2], gym2);
  gyms = await gymDatabase.getNearest(queryLocation, 1000000, 1);
  expect(gyms.length).toBe(1);
  compareGyms(gyms[0], gym3);
  gyms = await gymDatabase.getNearest(queryLocation, 1000000, 4);
  expect(gyms.length).toBe(3);
  compareGyms(gyms[0], gym3);
  compareGyms(gyms[1], gym1);
  compareGyms(gyms[2], gym2);
});
