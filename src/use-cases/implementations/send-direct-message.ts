import { inject, injectable } from "inversify";
import { Repositories } from "../../common/dependency-injection";
import { IMessageEntity, IPopulatedConversationEntity } from "../../entities";
import {
  IConversationRepository,
  IMessageRepository,
  IRelationshipRepository,
  IUserRepository,
} from "../../repositories/interfaces";
import { ISendDirectMessageUseCase } from "../interfaces";

@injectable()
export class SendDirectMessageUseCase implements ISendDirectMessageUseCase {
  messageRepo: IMessageRepository;
  conversationRepo: IConversationRepository;
  relationshipRepo: IRelationshipRepository;
  userRepo: IUserRepository;

  constructor(
    @inject(Repositories.message)
    messageRepo: IMessageRepository,
    @inject(Repositories.conversation)
    conversationRepo: IConversationRepository,
    @inject(Repositories.relationship)
    relationshipRepo: IRelationshipRepository,
    @inject(Repositories.user)
    userRepo: IUserRepository
  ) {
    this.messageRepo = messageRepo;
    this.conversationRepo = conversationRepo;
    this.relationshipRepo = relationshipRepo;
    this.userRepo = userRepo;
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

      const populatedConversation =
        await this.userRepo.populateConversationMembers(conversation);

      const message = await this.messageRepo.create({
        conversationId: conversation._id,
        userCognitoId: senderCognitoId,
        text: text,
      });
      return [populatedConversation, message] as [
        IPopulatedConversationEntity,
        IMessageEntity
      ];
    } else {
      throw new Error("You can only send messages to friends");
    }
  }
}
