import { Message, kMessageParser, messageToDynamo } from "./message";
import { SerializedDynamo, parseDynamo } from "./dynamo";

const testMessage: Message = {
  senderId: "1",
  text: "hi",
  createdAt: new Date(Date.UTC(2020, 1, 1)),
  id: "1",
};

const serializedMessage: SerializedDynamo<Message> = {
  senderId: { S: "1" },
  text: { S: "hi" },
  createdAt: { N: Date.UTC(2020, 1, 1).toString() },
  id: { S: "1" },
};

describe("Message", () => {
  it("serializes to dynamo", () => {
    expect(messageToDynamo(testMessage)).toEqual(serializedMessage);
  });

  it("deserializes from dynamo", () => {
    expect(parseDynamo(serializedMessage, kMessageParser)).toEqual(testMessage);
  });
});
