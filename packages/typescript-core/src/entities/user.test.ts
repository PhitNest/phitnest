import { SerializedDynamo, parseDynamo } from "./dynamo";
import { User, kUserParser, userToDynamo } from "./user";

const kTestUser: User = {
  id: "test",
  email: "test",
  createdAt: new Date(Date.UTC(2020, 1, 1)),
  firstName: "test",
  lastName: "test",
  identityId: "test",
};

const kSerializedUser: SerializedDynamo<User> = {
  id: { S: "test" },
  email: { S: "test" },
  createdAt: { N: Date.UTC(2020, 1, 1).toString() },
  firstName: { S: "test" },
  lastName: { S: "test" },
  identityId: { S: "test" },
};

describe("User", () => {
  it("serializes to dynamo", () => {
    expect(userToDynamo(kTestUser)).toEqual(kSerializedUser);
  });

  it("deserializes from dynamo", () => {
    expect(parseDynamo(kSerializedUser, kUserParser)).toEqual(kTestUser);
  });
});
