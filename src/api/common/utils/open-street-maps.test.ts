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
    expect(location!.longitude).toBeCloseTo(-75.996, 2);
    expect(location!.latitude).toBeCloseTo(36.85, 2);
    location = await getLocation(testAddress2);
    expect(location).not.toBeNull();
    expect(location!.longitude).toBeCloseTo(-80.413, 2);
    expect(location!.latitude).toBeCloseTo(37.229, 2);
  });
});
