import { dependencies, Repositories } from "../../common/dependency-injection";
import { ILocationRepository } from "../interfaces";

const testAddress1 = {
  street: "522 Pine Song Ln",
  city: "Virginia Beach",
  state: "VA",
  zipCode: "23451",
};

const testAddress2 = {
  street: "413 E Roanoke St",
  city: "Blacksburg",
  state: "VA",
  zipCode: "24060",
};

let locationRepo: ILocationRepository;

test("Get location from address", async () => {
  locationRepo = dependencies.get(Repositories.location);
  let location = await locationRepo.get(testAddress1);
  expect(location).not.toBeNull();
  expect(location!.type).toBe("Point");
  expect(location!.coordinates).toBeDefined();
  expect(location!.coordinates!.length).toBe(2);
  expect(location!.coordinates![0]).toBeCloseTo(-75.996, 2);
  expect(location!.coordinates![1]).toBeCloseTo(36.85, 2);
  location = await locationRepo.get(testAddress2);
  expect(location).not.toBeNull();
  expect(location!.type).toBe("Point");
  expect(location!.coordinates).toBeDefined();
  expect(location!.coordinates!.length).toBe(2);
  expect(location!.coordinates![0]).toBeCloseTo(-80.413, 2);
  expect(location!.coordinates![1]).toBeCloseTo(37.229, 2);
});
