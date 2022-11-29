import { inject, injectable } from "inversify";
import { Repositories } from "../../common/dependency-injection";
import { IRelationshipRepository } from "../../repositories/interfaces";
import { IGetFriendsUseCase } from "../interfaces";

@injectable()
export class GetFriendsUseCase implements IGetFriendsUseCase {
  relationshipRepo: IRelationshipRepository;

  constructor(
    @inject(Repositories.relationship) relationshipRepo: IRelationshipRepository
  ) {
    this.relationshipRepo = relationshipRepo;
  }

  async execute(userId: string) {
    return this.relationshipRepo.getFriends(userId);
  }
}
