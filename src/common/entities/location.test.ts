import { Location, kLocationParser, locationToDynamo } from "./location";
import { SerializedDynamo, parseDynamo } from "./dynamo";

const testLocation: Location = {
  longitude: 1,
  latitude: 2,
};

const serializedLocation: SerializedDynamo<Location> = {
  longitude: { N: "1" },
  latitude: { N: "2" },
};

describe("Location", () => {
  it("serializes to dynamo", () => {
    expect(locationToDynamo(testLocation)).toEqual(serializedLocation);
  });

  it("deserializes from dynamo", () => {
    expect(parseDynamo(serializedLocation, kLocationParser)).toEqual(
      testLocation
    );
  });
});
