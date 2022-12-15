import { inject, injectable } from "inversify";
import { Repositories } from "../../common/dependency-injection";
import {
  IConversationRepository,
  IMessageRepository,
  IRelationshipRepository,
} from "../../repositories/interfaces";
import { ISendDirectMessageUseCase } from "../interfaces";

@injectable()
export class SendDirectMessageUseCase implements ISendDirectMessageUseCase {
  messageRepo: IMessageRepository;
  conversationRepo: IConversationRepository;
  relationshipRepo: IRelationshipRepository;

  constructor(
    @inject(Repositories.message)
    messageRepo: IMessageRepository,
    @inject(Repositories.conversation)
    conversationRepo: IConversationRepository,
    @inject(Repositories.relationship)
    relationshipRepo: IRelationshipRepository
  ) {
    this.messageRepo = messageRepo;
    this.conversationRepo = conversationRepo;
    this.relationshipRepo = relationshipRepo;
  }

  async execute(
    senderCognitoId: string,
    recipientCognitoId: string,
    text: string
  ) {
    if (
      await this.relationshipRepo.isFriend(senderCognitoId, recipientCognitoId)
    ) {
      let conversation = await this.conversationRepo.getByUsers([
        senderCognitoId,
        recipientCognitoId,
      ]);
      if (!conversation) {
        conversation = await this.conversationRepo.create([
          senderCognitoId,
          recipientCognitoId,
        ]);
      }
      return await this.messageRepo.create({
        conversationId: conversation._id,
        userCognitoId: senderCognitoId,
        text: text,
      });
    } else {
      throw new Error("You can only send messages to friends");
    }
  }
}
