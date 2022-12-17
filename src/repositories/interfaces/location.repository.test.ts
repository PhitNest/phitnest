import { compareLocation } from "../../../test/helpers/comparisons";
import { dependencies, Repositories } from "../../common/dependency-injection";
import { LocationEntity } from "../../entities";
import { ILocationRepository } from ".";

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

const fakeAddress = {
  street: "1234 Main St",
  city: "Blacksburg",
  state: "CA",
  zipCode: "25060",
};

let locationRepo: ILocationRepository;

test("Get location from address", async () => {
  locationRepo = dependencies.get(Repositories.location);
  let location = await locationRepo.get(testAddress1);
  expect(location).not.toBeNull();
  compareLocation(location!, new LocationEntity(-75.996, 36.85));
  location = await locationRepo.get(testAddress2);
  expect(location).not.toBeNull();
  compareLocation(location!, new LocationEntity(-80.413, 37.229));
  location = await locationRepo.get(fakeAddress);
  expect(location).toBeNull();
});
