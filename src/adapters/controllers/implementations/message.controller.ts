import { inject, injectable } from "inversify";
import { z } from "zod";
import { UseCases } from "../../../common/dependency-injection";
import {
  statusBadRequest,
  statusInternalServerError,
  statusOK,
} from "../../../constants/http_codes";
import { IGetMessagesUseCase } from "../../../use-cases/interfaces";
import { IRequest, IResponse } from "../../types";
import { IMessageController } from "../interfaces";

@injectable()
export class MessageController implements IMessageController {
  getMessagesUseCase: IGetMessagesUseCase;

  constructor(
    @inject(UseCases.getMessages) getMessagesUseCase: IGetMessagesUseCase
  ) {
    this.getMessagesUseCase = getMessagesUseCase;
  }

  async getMessages(req: IRequest, res: IResponse) {
    try {
      const { conversationId, skip, limit } = z
        .object({
          conversationId: z.string(),
          skip: z.number().min(0).optional(),
          limit: z.number().min(0).max(100).optional(),
        })
        .parse(req.content());
      return res
        .status(statusOK)
        .json(
          await this.getMessagesUseCase.execute(
            res.locals.cognitoId,
            conversationId
          )
        );
    } catch (err) {
      if (err instanceof z.ZodError) {
        return res.status(statusBadRequest).json(err.issues);
      } else if (err instanceof Error) {
        return res.status(statusInternalServerError).json(err.message);
      } else {
        return res.status(statusInternalServerError).send(err);
      }
    }
  }
}
