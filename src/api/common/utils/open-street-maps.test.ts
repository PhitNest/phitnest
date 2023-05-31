import { Location } from "../entities";
import { getLocation } from "./open-street-maps";

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

describe("getLocation", () => {
  it("should return a location for a valid address", async () => {
    let location = await getLocation(testAddress1);
    expect(location).not.toBeNull();
    let notNullLocation = location as Location;
    expect(notNullLocation.longitude).toBeCloseTo(-75.996, 2);
    expect(notNullLocation.latitude).toBeCloseTo(36.85, 2);
    location = await getLocation(testAddress2);
    expect(location).not.toBeNull();
    notNullLocation = location as Location;
    expect(notNullLocation.longitude).toBeCloseTo(-80.413, 2);
    expect(notNullLocation.latitude).toBeCloseTo(37.229, 2);
  });
});
