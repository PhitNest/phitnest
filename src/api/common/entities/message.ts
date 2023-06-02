import {
  CreationDetails,
  creationDetailsToDynamo,
  kCreationDetailsDynamo,
} from "./account";
import { Dynamo, DynamoShape } from "./dynamo";

export type Message = CreationDetails & {
  senderId: string;
  text: string;
};

export const kMessageDynamo: DynamoShape<Message> = {
  senderId: "S",
  text: "S",
  ...kCreationDetailsDynamo,
};

export function messageToDynamo(message: Message): Dynamo<Message> {
  return {
    senderId: { S: message.senderId },
    text: { S: message.text },
    ...creationDetailsToDynamo(message),
  };
}
