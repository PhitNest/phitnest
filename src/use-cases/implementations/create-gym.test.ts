import { compareGym } from "../../../test/helpers/comparisons";
import { dependencies, UseCases } from "../../common/dependency-injection";
import { ICreateGymUseCase } from "../interfaces";

const testGym1 = {
  name: "Planet Fitness",
  address: {
    street: "522 Pine Song Ln",
    city: "Virginia Beach",
    state: "VA",
    zipCode: "23451",
  },
  location: {
    type: "Point",
    coordinates: [-75.996, 36.85],
  },
};

const testGym2 = {
  name: "Gold's Gym",
  address: {
    street: "413 E Roanoke St",
    city: "Blacksburg",
    state: "VA",
    zipCode: "24060",
  },
  location: {
    type: "Point",
    coordinates: [-80.413, 37.229],
  },
};

const fakeAddress = {
  street: "1234 Main St",
  city: "Blacksburg",
  state: "CA",
  zipCode: "25060",
};

let createGym: ICreateGymUseCase;

test("Can search for a location from an address and create a gym with it", async () => {
  createGym = dependencies.get(UseCases.createGym);
  let gym = await createGym.execute(testGym1.name, testGym1.address);
  compareGym(gym, testGym1);
  gym = await createGym.execute(testGym2.name, testGym2.address);
  compareGym(gym, testGym2);
  await expect(createGym.execute(testGym1.name, fakeAddress)).rejects.toThrow();
});
