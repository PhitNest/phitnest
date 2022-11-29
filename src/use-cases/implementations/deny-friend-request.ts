import { inject, injectable } from "inversify";
import { Repositories } from "../../common/dependency-injection";
import { IRelationshipRepository } from "../../repositories/interfaces";
import { IDenyFriendRequestUseCase } from "../interfaces";

@injectable()
export class DenyFriendRequestUseCase implements IDenyFriendRequestUseCase {
  relationshipRepo: IRelationshipRepository;

  constructor(
    @inject(Repositories.relationship) relationshipRepo: IRelationshipRepository
  ) {
    this.relationshipRepo = relationshipRepo;
  }

  execute(senderId: string, recipientId: string) {
    return this.relationshipRepo.createDeny(senderId, recipientId);
  }
}
