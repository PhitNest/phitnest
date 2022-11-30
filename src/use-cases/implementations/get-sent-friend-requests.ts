import { inject, injectable } from "inversify";
import { Repositories } from "../../common/dependency-injection";
import { IRelationshipRepository } from "../../repositories/interfaces";
import { IGetSentFriendRequestsUseCase } from "../interfaces";

@injectable()
export class GetSentFriendRequestsUseCase
  implements IGetSentFriendRequestsUseCase
{
  relationshipRepo: IRelationshipRepository;

  constructor(
    @inject(Repositories.relationship) relationshipRepo: IRelationshipRepository
  ) {
    this.relationshipRepo = relationshipRepo;
  }

  execute(cognitoId: string) {
    return this.relationshipRepo.getPendingOutboundRequests(cognitoId);
  }
}
