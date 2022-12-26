import { inject, injectable } from "inversify";
import { Repositories } from "../../common/dependency-injection";
import {
  IConversationRepository,
  IMessageRepository,
} from "../../repositories/interfaces";
import { ISendMessageUseCase } from "../interfaces";

@injectable()
export class SendMessageUseCase implements ISendMessageUseCase {
  messageRepo: IMessageRepository;
  conversationRepo: IConversationRepository;

  constructor(
    @inject(Repositories.message)
    messageRepo: IMessageRepository,
    @inject(Repositories.conversation)
    conversationRepo: IConversationRepository
  ) {
    this.messageRepo = messageRepo;
    this.conversationRepo = conversationRepo;
  }

  async execute(senderCognitoId: string, conversationId: string, text: string) {
    if (
      await this.conversationRepo.isUserInConversation(
        senderCognitoId,
        conversationId
      )
    ) {
      const message = await this.messageRepo.create({
        conversationId: conversationId,
        userCognitoId: senderCognitoId,
        text: text,
      });
      return message;
    } else {
      throw new Error("You are not a part of this conversation.");
    }
  }
}
