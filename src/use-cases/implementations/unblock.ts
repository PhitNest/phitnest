import { inject, injectable } from "inversify";
import { Repositories } from "../../common/dependency-injection";
import { IRelationshipRepository } from "../../repositories/interfaces";
import { IUnblockUseCase } from "../interfaces";

@injectable()
export class UnblockUseCase implements IUnblockUseCase {
  relationshipRepo: IRelationshipRepository;

  constructor(
    @inject(Repositories.relationship) relationshipRepo: IRelationshipRepository
  ) {
    this.relationshipRepo = relationshipRepo;
  }

  execute(senderId: string, recipientId: string) {
    return this.relationshipRepo.deleteBlock(senderId, recipientId);
  }
}
