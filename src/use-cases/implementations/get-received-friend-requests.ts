import { inject, injectable } from "inversify";
import { Repositories } from "../../common/dependency-injection";
import { IRelationshipRepository } from "../../repositories/interfaces";
import { IGetReceivedFriendRequestsUseCase } from "../interfaces";

@injectable()
export class GetReceivedFriendRequestsUseCase
  implements IGetReceivedFriendRequestsUseCase
{
  relationshipRepo: IRelationshipRepository;

  constructor(
    @inject(Repositories.relationship) relationshipRepo: IRelationshipRepository
  ) {
    this.relationshipRepo = relationshipRepo;
  }

  execute(cognitoId: string) {
    return this.relationshipRepo.getPendingInboundRequests(cognitoId);
  }
}
