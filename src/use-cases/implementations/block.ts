import { inject, injectable } from "inversify";
import { Repositories } from "../../common/dependency-injection";
import {
  IConversationRepository,
  IRelationshipRepository,
} from "../../repositories/interfaces";
import { IBlockUseCase } from "../interfaces";

@injectable()
export class BlockUseCase implements IBlockUseCase {
  relationshipRepo: IRelationshipRepository;
  conversationRepo: IConversationRepository;

  constructor(
    @inject(Repositories.relationship)
    relationshipRepo: IRelationshipRepository,
    @inject(Repositories.conversation) conversationRepo: IConversationRepository
  ) {
    this.relationshipRepo = relationshipRepo;
    this.conversationRepo = conversationRepo;
  }

  async execute(senderId: string, recipientId: string) {
    await this.relationshipRepo.createBlock(senderId, recipientId);
    const conversation = await this.conversationRepo.getByUsers([
      senderId,
      recipientId,
    ]);
    if (conversation) {
      await this.conversationRepo.archive(conversation._id);
    }
  }
}
