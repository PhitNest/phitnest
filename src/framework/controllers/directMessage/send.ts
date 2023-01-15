import {
  AuthenticatedLocals,
  Failure,
  IRequest,
  IResponse,
} from "../../../common/types";
import { z } from "zod";
import { Controller, HttpMethod } from "../types";
import { authMiddleware } from "../../middleware";
import { IDirectMessageEntity } from "../../../domain/entities";
import { sendDirectMessage } from "../../../domain/use-cases";
import { getSocketServer } from "../../adapters/injection";

const sendDirectMessageValidator = z.object({
  recipientCognitoId: z.string(),
  text: z.string().trim().min(1).max(1000),
});

type SendDirectMessageRequest = z.infer<typeof sendDirectMessageValidator>;

export class SendDirectMessageController
  implements
    Controller<
      SendDirectMessageRequest,
      IDirectMessageEntity,
      AuthenticatedLocals
    >
{
  method = HttpMethod.POST;

  middleware = [authMiddleware];

  validate(body: any) {
    return sendDirectMessageValidator.parse(body);
  }

  async execute(
    req: IRequest<SendDirectMessageRequest>,
    res: IResponse<IDirectMessageEntity, AuthenticatedLocals>
  ) {
    const message = sendDirectMessage(
      res.locals.cognitoId,
      req.body.recipientCognitoId,
      req.body.text
    );
    if (message instanceof Failure) {
      return message;
    } else {
      getSocketServer().emit(
        "directMessage",
        message,
        req.body.recipientCognitoId
      );
      return message;
    }
  }
}
