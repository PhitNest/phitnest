import { Location, kLocationParser, locationToDynamo } from "./location";
import { SerializedDynamo, parseDynamo } from "./dynamo";

const kTestLocation: Location = {
  longitude: 1,
  latitude: 2,
};

const kSerializedLocation: SerializedDynamo<Location> = {
  longitude: { N: "1" },
  latitude: { N: "2" },
};

describe("Location", () => {
  it("serializes to dynamo", () => {
    expect(locationToDynamo(kTestLocation)).toEqual(kSerializedLocation);
  });

  it("deserializes from dynamo", () => {
    expect(parseDynamo(kSerializedLocation, kLocationParser)).toEqual(
      kTestLocation,
    );
  });
});
