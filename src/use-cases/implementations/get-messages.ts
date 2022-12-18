import { inject, injectable } from "inversify";
import { Repositories } from "../../common/dependency-injection";
import {
  IConversationRepository,
  IMessageRepository,
} from "../../repositories/interfaces";
import { IGetMessagesUseCase } from "../interfaces";

@injectable()
export class GetMessagesUseCase implements IGetMessagesUseCase {
  conversationRepo: IConversationRepository;
  messageRepo: IMessageRepository;

  constructor(
    @inject(Repositories.conversation)
    conversationRepo: IConversationRepository,
    @inject(Repositories.message) messageRepo: IMessageRepository
  ) {
    this.conversationRepo = conversationRepo;
    this.messageRepo = messageRepo;
  }

  async execute(
    userCognitoId: string,
    conversationId: string,
    offset?: number | undefined,
    limit?: number | undefined
  ) {
    if (
      await this.conversationRepo.isUserInConversation(
        userCognitoId,
        conversationId
      )
    ) {
      return await this.messageRepo.get(conversationId, offset, limit);
    } else {
      throw new Error("You are not a part of this conversation.");
    }
  }
}
