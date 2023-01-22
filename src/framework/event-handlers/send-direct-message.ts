import { z } from "zod";
import { Failure } from "../../common/types";
import { sendDirectMessage } from "../../domain/use-cases";
import { IConnection } from "../adapters/interfaces";

const sendDirectMessageValidator = z.object({
  recipientCognitoId: z.string(),
  text: z.string().trim().min(1).max(1000),
});

export function validateSendDirectMessage(data: any) {
  return sendDirectMessageValidator.parse(data);
}

type SendDirectMessageRequest = z.infer<typeof sendDirectMessageValidator>;

export async function handleSendDirectMessage(
  data: SendDirectMessageRequest,
  connection: IConnection
) {
  const message = await sendDirectMessage(
    connection.cognitoId,
    data.recipientCognitoId,
    data.text
  );
  if (message instanceof Failure) {
    return message;
  } else {
    connection.broadcast("directMessage", message, data.recipientCognitoId);
    return message;
  }
}
