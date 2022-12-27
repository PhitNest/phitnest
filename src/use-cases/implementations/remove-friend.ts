import { inject, injectable } from "inversify";
import { Repositories } from "../../common/dependency-injection";
import { IRelationshipRepository } from "../../repositories/interfaces";
import { IRemoveFriendUseCase } from "../interfaces";

@injectable()
export class RemoveFriendUseCase implements IRemoveFriendUseCase {
  relationshipRepo: IRelationshipRepository;

  constructor(
    @inject(Repositories.relationship) relationshipRepo: IRelationshipRepository
  ) {
    this.relationshipRepo = relationshipRepo;
  }

  async execute(cognitoId: string, friendId: string) {
    if (!(await this.relationshipRepo.deleteFriendship(cognitoId, friendId))) {
      throw new Error("You are not friends with this user.");
    }
  }
}
