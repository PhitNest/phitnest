import { Admin, adminToDynamo, kAdminParser } from "./admin";
import { SerializedDynamo, parseDynamo } from "./dynamo";

const kTestAdmin: Admin = {
  email: "something",
  id: "1",
  createdAt: new Date(Date.UTC(2020, 1, 1)),
};

const kSerializedAdmin: SerializedDynamo<Admin> = {
  email: { S: "something" },
  id: { S: "1" },
  createdAt: { N: Date.UTC(2020, 1, 1).toString() },
};

describe("Admin", () => {
  it("serializes to dynamo", () => {
    expect(adminToDynamo(kTestAdmin)).toEqual(kSerializedAdmin);
  });

  it("deserializes from dynamo", () => {
    expect(parseDynamo(kSerializedAdmin, kAdminParser)).toEqual(kTestAdmin);
  });
});
