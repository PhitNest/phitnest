import { z } from "zod";
import { Failure } from "../../common/types";
import { IDirectMessageEntity } from "../../domain/entities";
import { sendDirectMessage } from "../../domain/use-cases";
import { IConnection } from "../adapters/interfaces";
import { EventHandler } from "./types";

export class SendDirectMessageHandler
  implements EventHandler<IDirectMessageEntity>
{
  event = "directMessage";

  validator = z.object({
    recipientCognitoId: z.string(),
    text: z.string().trim().min(1).max(1000),
  });

  async execute(data: z.infer<typeof this.validator>, connection: IConnection) {
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
}
