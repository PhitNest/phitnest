import { kLocationNotFound } from "../../../../common/failures";
import dataSources from "../../injection";

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
  const { locationDatabase } = dataSources();
  expect(await locationDatabase.get(testAddress1)).toEqual(expectedLocation1);
  expect(await locationDatabase.get(testAddress2)).toEqual(expectedLocation2);
  expect(await locationDatabase.get(fakeAddress)).toBe(kLocationNotFound);
});
