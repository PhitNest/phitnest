import { fail } from "assert";
import { kLocationNotFound } from "../../common/failures";
import { locationRepository } from "../injection";

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

const expectedLocation1 = {
  type: "Point",
  coordinates: [-75.99618967933559, 36.8497312] as [number, number],
};

const expectedLocation2 = {
  type: "Point",
  coordinates: [-80.4138162, 37.2294115] as [number, number],
};

test("Get location from address", async () => {
  const locationRepo = locationRepository();
  let location = await locationRepo.get(testAddress1);
  location.tap({
    left: (location) => {
      expect(location).toEqual(expectedLocation1);
    },
    right: (failure) => {
      console.log(`Unexpected failure: ${failure}`);
      fail(
        `testAddress1 failed with address:\n${JSON.stringify(testAddress1)}`
      );
    },
  });
  location = await locationRepo.get(testAddress2);
  location.tap({
    left: (location) => {
      expect(location).toEqual(expectedLocation2);
    },
    right: (failure) => {
      console.log(`Unexpected failure: ${failure}`);
      fail(
        `testAddress2 failed with address:\n${JSON.stringify(testAddress2)}`
      );
    },
  });
  location = await locationRepo.get(fakeAddress);
  location.tap({
    left: (location) => {
      console.log(`Unexpected success: ${location.coordinates}`);
      fail(`An invalid address did not fail:\n${JSON.stringify(fakeAddress)}`);
    },
    right: (failure) => {
      expect(failure).toBe(kLocationNotFound);
    },
  });
});
