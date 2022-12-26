import { inject, injectable } from "inversify";
import { Repositories } from "../../common/dependency-injection";
import { IConversationRepository } from "../../repositories/interfaces";
import { IGetConversationsUseCase } from "../interfaces";

@injectable()
export class GetConversationsUseCase implements IGetConversationsUseCase {
  conversationRepo: IConversationRepository;

  constructor(
    @inject(Repositories.conversation)
    conversationRepo: IConversationRepository
  ) {
    this.conversationRepo = conversationRepo;
  }

  execute(cognitoId: string) {
    return this.conversationRepo.getByUser(cognitoId);
  }
}
