import { SerializedDynamo, DynamoParser } from "./dynamo";

export type Message = {
  id: string;
  senderId: string;
  text: string;
  createdAt: Date;
};

export const kMessageParser: DynamoParser<Message> = {
  id: "S",
  senderId: "S",
  text: "S",
  createdAt: "D",
};

export function messageToDynamo(message: Message): SerializedDynamo<Message> {
  return {
    id: { S: message.id },
    senderId: { S: message.senderId },
    text: { S: message.text },
    createdAt: { N: message.createdAt.getTime().toString() },
  };
}
