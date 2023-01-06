import {
  IConversationEntity,
  IPopulatedConversationEntity,
  IPublicUserEntity,
  IRegisteredUser,
  IUserEntity,
} from "../../entities";

export interface IUserRepository {
  create(user: Omit<IUserEntity, "_id">): Promise<IUserEntity>;

  delete(cognitoId: string): Promise<boolean>;

  confirmUser(cognitoId: string): Promise<void>;

  getByEmail(email: string): Promise<IRegisteredUser | null>;

  exploreUsers(
    cognitoId: string,
    skip?: number,
    limit?: number
  ): Promise<Omit<IPublicUserEntity, "gymId">[]>;

  tutorialExploreUsers(
    gymId: string,
    skip?: number,
    limit?: number
  ): Promise<Omit<IPublicUserEntity, "gymId">[]>;

  get(cognitoId: string): Promise<IUserEntity | null>;

  haveSameGym(cognitoId1: string, cognitoId2: string): Promise<boolean>;

  populateConversationMembers(
    conversation: IConversationEntity
  ): Promise<IPopulatedConversationEntity>;

  deleteAll(): Promise<void>;
}
