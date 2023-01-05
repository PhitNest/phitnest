import { inject, injectable } from "inversify";
import { Repositories } from "../../common/dependency-injection";
import {
  IConversationRepository,
  IRelationshipRepository,
} from "../../repositories/interfaces";
import { IRemoveFriendUseCase } from "../interfaces";

@injectable()
export class RemoveFriendUseCase implements IRemoveFriendUseCase {
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

  async execute(cognitoId: string, friendId: string) {
    if (!(await this.relationshipRepo.deleteFriendship(cognitoId, friendId))) {
      throw new Error("You are not friends with this user.");
    }

    const conversation = await this.conversationRepo.getByUsers([
      cognitoId,
      friendId,
    ]);

    if (conversation) {
      await this.conversationRepo.archive(conversation._id);
    }
  }
}
