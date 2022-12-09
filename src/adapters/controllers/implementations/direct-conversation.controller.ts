import { inject, injectable } from "inversify";
import { UseCases } from "../../../common/dependency-injection";
import { IGetRecentDirectConversationsUseCase } from "../../../use-cases/interfaces";
import { AuthenticatedLocals, IRequest, IResponse } from "../../types";
import { IDirectConversationController } from "../interfaces";

@injectable()
export class DirectConversationController
  implements IDirectConversationController
{
  getRecentDirectConversationsUseCase: IGetRecentDirectConversationsUseCase;

  constructor(
    @inject(UseCases.getRecentDirectConversations)
    getRecentDirectConversationsUseCase: IGetRecentDirectConversationsUseCase
  ) {
    this.getRecentDirectConversationsUseCase =
      getRecentDirectConversationsUseCase;
  }

  async getRecentDirectConversations(
    req: IRequest,
    res: IResponse<AuthenticatedLocals>
  ) {
    try {
      return res
        .status(200)
        .json(
          await this.getRecentDirectConversationsUseCase.execute(
            res.locals.cognitoId
          )
        );
    } catch (err) {
      if (err instanceof Error) {
        return res.status(500).json({ message: err.message });
      } else {
        return res.status(500).send(err);
      }
    }
  }
}
