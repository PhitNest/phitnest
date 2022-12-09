import { inject, injectable } from "inversify";
import { UseCases } from "../../../common/dependency-injection";
import { IGetDirectConversationsUseCase } from "../../../use-cases/interfaces";
import { AuthenticatedLocals, IRequest, IResponse } from "../../types";
import { IDirectConversationController } from "../interfaces";

@injectable()
export class DirectConversationController
  implements IDirectConversationController
{
  getDirectConversationsUseCase: IGetDirectConversationsUseCase;

  constructor(
    @inject(UseCases.getDirectConversations)
    getDirectConversationsUseCase: IGetDirectConversationsUseCase
  ) {
    this.getDirectConversationsUseCase = getDirectConversationsUseCase;
  }

  async getDirectConversations(
    req: IRequest,
    res: IResponse<AuthenticatedLocals>
  ) {
    try {
      return res
        .status(200)
        .json(
          await this.getDirectConversationsUseCase.execute(res.locals.cognitoId)
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
