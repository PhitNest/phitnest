import { inject, injectable } from "inversify";
import { Repositories } from "../../common/dependency-injection";
import {
  IRelationshipRepository,
  IUserRepository,
} from "../../repositories/interfaces";
import { ISendFriendRequestUseCase } from "../interfaces";

@injectable()
export class SendFriendRequestUseCase implements ISendFriendRequestUseCase {
  relationshipRepo: IRelationshipRepository;
  userRepo: IUserRepository;

  constructor(
    @inject(Repositories.relationship)
    relationshipRepo: IRelationshipRepository,
    @inject(Repositories.user) userRepo: IUserRepository
  ) {
    this.relationshipRepo = relationshipRepo;
    this.userRepo = userRepo;
  }

  async execute(senderId: string, recipientId: string) {
    if (await this.userRepo.haveSameGym(senderId, recipientId)) {
      return this.relationshipRepo.createRequest(senderId, recipientId);
    } else {
      throw new Error("Users are not in the same gym");
    }
  }
}
