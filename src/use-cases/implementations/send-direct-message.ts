import { inject, injectable } from "inversify";
import { Repositories } from "../../common/dependency-injection";
import {
  IDirectConversationRepository,
  IMessageRepository,
  IRelationshipRepository,
} from "../../repositories/interfaces";
import { ISendDirectMessageUseCase } from "../interfaces";

@injectable()
export class SendDirectMessageUseCase implements ISendDirectMessageUseCase {
  messageRepo: IMessageRepository;
  directConversationRepo: IDirectConversationRepository;
  relationshipRepo: IRelationshipRepository;

  constructor(
    @inject(Repositories.message)
    messageRepo: IMessageRepository,
    @inject(Repositories.directConversation)
    directConversationRepo: IDirectConversationRepository,
    @inject(Repositories.relationship)
    relationshipRepo: IRelationshipRepository
  ) {
    this.messageRepo = messageRepo;
    this.directConversationRepo = directConversationRepo;
    this.relationshipRepo = relationshipRepo;
  }

  async execute(
    senderCognitoId: string,
    recipientCognitoId: string,
    text: string
  ) {
    if (
      await this.relationshipRepo.friends(senderCognitoId, recipientCognitoId)
    ) {
      let conversation = await this.directConversationRepo.getByUsers([
        senderCognitoId,
        recipientCognitoId,
      ]);
      if (!conversation) {
        conversation = await this.directConversationRepo.create([
          senderCognitoId,
          recipientCognitoId,
        ]);
      }
      return await this.messageRepo.create({
        conversationId: conversation._id,
        senderCognitoId: senderCognitoId,
        text: text,
      });
    } else {
      throw new Error("You can only send messages to friends");
    }
  }
}
