import { inject, injectable } from "inversify";
import { Repositories } from "../../common/dependency-injection";
import { IDirectConversationRepository } from "../../repositories/interfaces";
import { IGetRecentDirectConversationsUseCase } from "../interfaces";

@injectable()
export class GetRecentDirectConversationsUseCase
  implements IGetRecentDirectConversationsUseCase
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
