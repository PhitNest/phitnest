import { inject, injectable } from "inversify";
import { Repositories } from "../../common/dependency-injection";
import { IRelationshipRepository } from "../../repositories/interfaces";
import { ISendFriendRequestUseCase } from "../interfaces";

@injectable()
export class SendFriendRequestUseCase implements ISendFriendRequestUseCase {
  relationshipRepo: IRelationshipRepository;

  constructor(
    @inject(Repositories.relationship) relationshipRepo: IRelationshipRepository
  ) {
    this.relationshipRepo = relationshipRepo;
  }

  execute(senderId: string, recipientId: string) {
    return this.relationshipRepo.createRequest(senderId, recipientId);
  }
}
