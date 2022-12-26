import { inject, injectable } from "inversify";
import { Repositories } from "../../common/dependency-injection";
import { IConversationRepository } from "../../repositories/interfaces";
import { IGetRecentConversationsUseCase } from "../interfaces";

@injectable()
export class GetRecentConversationsUseCase
  implements IGetRecentConversationsUseCase
{
  conversationRepo: IConversationRepository;

  constructor(
    @inject(Repositories.conversation)
    conversationRepo: IConversationRepository
  ) {
    this.conversationRepo = conversationRepo;
  }

  execute(cognitoId: string) {
    return this.conversationRepo.getRecentMessages(cognitoId);
  }
}
