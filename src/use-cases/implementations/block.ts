import { inject, injectable } from "inversify";
import { Repositories } from "../../common/dependency-injection";
import { IRelationshipRepository } from "../../repositories/interfaces";
import { IBlockUseCase } from "../interfaces";

@injectable()
export class BlockUseCase implements IBlockUseCase {
  relationshipRepo: IRelationshipRepository;

  constructor(
    @inject(Repositories.relationship) relationshipRepo: IRelationshipRepository
  ) {
    this.relationshipRepo = relationshipRepo;
  }

  execute(senderId: string, recipientId: string) {
    return this.relationshipRepo.createBlock(senderId, recipientId);
  }
}
