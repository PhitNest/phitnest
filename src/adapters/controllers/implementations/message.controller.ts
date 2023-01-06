import { inject, injectable } from "inversify";
import { z } from "zod";
import { UseCases } from "../../../common/dependency-injection";
import {
  statusInternalServerError,
  statusOK,
} from "../../../constants/http_codes";
import { IMessageEntity } from "../../../entities";
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

  async getMessages(req: IRequest, res: IResponse<IMessageEntity[]>) {
    try {
      const { conversationId } = z
        .object({
          conversationId: z.string(),
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
      return res.status(statusInternalServerError).send(err);
    }
  }
}
