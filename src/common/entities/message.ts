import {
  CreationDetails,
  creationDetailsToDynamo,
  kCreationDetailsParser,
} from "./account";
import { SerializedDynamo, DynamoParser } from "./dynamo";

export type Message = CreationDetails & {
  senderId: string;
  text: string;
};

export const kMessageParser: DynamoParser<Message> = {
  senderId: "S",
  text: "S",
  ...kCreationDetailsParser,
};

export function messageToDynamo(message: Message): SerializedDynamo<Message> {
  return {
    senderId: { S: message.senderId },
    text: { S: message.text },
    ...creationDetailsToDynamo(message),
  };
}
