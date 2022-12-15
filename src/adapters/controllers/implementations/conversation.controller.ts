import { inject, injectable } from "inversify";
import { UseCases } from "../../../common/dependency-injection";
import { IGetRecentConversationsUseCase } from "../../../use-cases/interfaces";
import { AuthenticatedLocals, IRequest, IResponse } from "../../types";
import { IConversationController } from "../interfaces";
import {
  statusInternalServerError,
  statusOK,
} from "../../../constants/http_codes";

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
    res: IResponse<AuthenticatedLocals>
  ) {
    try {
      return res
        .status(statusOK)
        .json(
          await this.getRecentConversationsUseCase.execute(res.locals.cognitoId)
        );
    } catch (err) {
      if (err instanceof Error) {
        return res
          .status(statusInternalServerError)
          .json({ message: err.message });
      } else {
        return res.status(statusInternalServerError).send(err);
      }
    }
  }
}
