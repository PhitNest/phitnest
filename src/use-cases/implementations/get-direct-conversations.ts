import { inject, injectable } from "inversify";
import { Repositories } from "../../common/dependency-injection";
import { IDirectConversationRepository } from "../../repositories/interfaces";
import { IGetDirectConversationsUseCase } from "../interfaces";

@injectable()
export class GetDirectConversationsUseCase
  implements IGetDirectConversationsUseCase
{
  directConversationRepo: IDirectConversationRepository;

  constructor(
    @inject(Repositories.directConversation)
    directConversationRepo: IDirectConversationRepository
  ) {
    this.directConversationRepo = directConversationRepo;
  }

  execute(cognitoId: string) {
    return this.directConversationRepo.getRecentMessages(cognitoId);
  }
}
