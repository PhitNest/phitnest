import { Admin, adminToDynamo, kAdminParser } from "./admin";
import { SerializedDynamo, parseDynamo } from "./dynamo";

const testAdmin: Admin = {
  email: "something",
  id: "1",
  createdAt: new Date(Date.UTC(2020, 1, 1)),
};

const serializedAdmin: SerializedDynamo<Admin> = {
  email: { S: "something" },
  id: { S: "1" },
  createdAt: { N: Date.UTC(2020, 1, 1).toString() },
};

describe("Admin", () => {
  it("serializes to dynamo", () => {
    expect(adminToDynamo(testAdmin)).toEqual(serializedAdmin);
  });

  it("deserializes from dynamo", () => {
    expect(parseDynamo(serializedAdmin, kAdminParser)).toEqual(testAdmin);
  });
});
