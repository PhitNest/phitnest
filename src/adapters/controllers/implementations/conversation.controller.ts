import { inject, injectable } from "inversify";
import { UseCases } from "../../../common/dependency-injection";
import { IGetRecentConversationsUseCase } from "../../../use-cases/interfaces";
import { IAuthenticatedResponse, IRequest } from "../../types";
import { IConversationController } from "../interfaces";
import {
  statusInternalServerError,
  statusOK,
} from "../../../constants/http_codes";
import {
  IMessageEntity,
  IPopulatedConversationEntity,
} from "../../../entities";

@injectable()
export class ConversationController implements IConversationController {
  getRecentConversationsUseCase: IGetRecentConversationsUseCase;

  constructor(
    @inject(UseCases.getRecentConversations)
    getRecentConversationsUseCase: IGetRecentConversationsUseCase
  ) {
    this.getRecentConversationsUseCase = getRecentConversationsUseCase;
  }

  async getRecentConversations(
    req: IRequest,
    res: IAuthenticatedResponse<
      { conversation: IPopulatedConversationEntity; message: IMessageEntity }[]
    >
  ) {
    try {
      return res
        .status(statusOK)
        .json(
          await this.getRecentConversationsUseCase.execute(res.locals.cognitoId)
        );
    } catch (err) {
      return res.status(statusInternalServerError).send(err);
    }
  }
}
