import "reflect-metadata";
import { Container, interfaces } from "inversify";

export const Repositories = {
  user: Symbol("user.repository"),
  auth: Symbol("auth.repository"),
  gym: Symbol("gym.repository"),
  relationship: Symbol("relationship.repository"),
  location: Symbol("location.repository"),
  directConversation: Symbol("directConversation.repository"),
  directMessage: Symbol("directMessage.repository"),
};

export const UseCases = {
  getGym: Symbol("getGym.use-case"),
  getNearestGyms: Symbol("getNearestGyms.use-case"),
  authenticate: Symbol("authenticate.use-case"),
  getUser: Symbol("getUser.use-case"),
  explore: Symbol("explore.use-case"),
  forgotPasswordSubmit: Symbol("forgotPasswordSubmit.use-case"),
  createGym: Symbol("createGym.use-case"),
  tutorialExplore: Symbol("tutorialExplore.use-case"),
  login: Symbol("login.use-case"),
  register: Symbol("register.use-case"),
  confirmRegister: Symbol("confirmRegister.use-case"),
  refreshSession: Symbol("refreshSession.use-case"),
  getReceivedFriendRequests: Symbol("getReceivedFriendRequests.use-case"),
  resendConfirmation: Symbol("resendConfirmation.use-case"),
  forgotPassword: Symbol("forgotPassword.use-case"),
  signOut: Symbol("signOut.use-case"),
  sendFriendRequest: Symbol("sendFriendRequest.use-case"),
  block: Symbol("block.use-case"),
  getSentFriendRequests: Symbol("getSentFriendRequests.use-case"),
  unblock: Symbol("unblock.use-case"),
  denyFriendRequest: Symbol("denyFriendRequest.use-case"),
  getFriends: Symbol("getFriends.use-case"),
  sendDirectMessage: Symbol("sendDirectMessage.use-case"),
  getRecentDirectConversations: Symbol("getRecentDirectConversations.use-case"),
};

export const Middlewares = {
  authenticate: Symbol("authenticate.middleware"),
};

export const Controllers = {
  gym: Symbol("gym.controller"),
  user: Symbol("user.controller"),
  auth: Symbol("auth.controller"),
  relationship: Symbol("relationship.controller"),
  directConversation: Symbol("directConversation.controller"),
};

export const EventHandlers = {
  onConnect: Symbol("onConnect.event-handler"),
  onDisconnect: Symbol("onDisconnect.event-handler"),
  sendDirectMessage: Symbol("sendMessage.event-handler"),
  sendFriendRequest: Symbol("sendFriendRequest.event-handler"),
};

// Make sure to export repositories, use cases, and controllers symbols before importing the following

import {
  MongoUserRepository,
  CognitoAuthRepository,
  MongoGymRepository,
  MongoRelationshipRepository,
  OSMLocationRepository,
  MongoDirectMessageRepository,
  MongoDirectConversationRepository,
} from "../repositories/implementations";

import {
  GetGymUseCase,
  GetNearestGymsUseCase,
  AuthenticateUseCase,
  GetUserUseCase,
  ExploreUseCase,
  CreateGymUseCase,
  LoginUseCase,
  RegisterUseCase,
  ConfirmRegisterUseCase,
  RefreshSessionUseCase,
  ResendConfirmationUseCase,
  ForgotPasswordUseCase,
  ForgotPasswordSubmitUseCase,
  SignOutUseCase,
  SendFriendRequestUseCase,
  BlockUseCase,
  UnblockUseCase,
  DenyFriendRequestUseCase,
  GetFriendsUseCase,
  GetSentFriendRequestsUseCase,
  GetReceivedFriendRequestsUseCase,
  SendDirectMessageUseCase,
  TutorialExploreUseCase,
  GetRecentDirectConversationsUseCase,
} from "../use-cases/implementations";

import { AuthMiddleware } from "../adapters/middleware/implementations";

import {
  GymController,
  UserController,
  AuthController,
  RelationshipController,
  DirectConversationController,
} from "../adapters/controllers/implementations";

import { l } from "./logger";

import { IUseCase } from "../use-cases/types";
import { IEventHandler } from "../adapters/types";
import {
  OnConnectEventHandler,
  OnDisconnectEventHandler,
  SendDirectMessageEventHandler,
  SendFriendRequestEventHandler,
} from "../adapters/event-handlers/implementations";

export let dependencies: Container;

export function injectRepository<Type>(
  repository: symbol,
  implementation: interfaces.Newable<Type>
) {
  if (dependencies.isBound(repository)) {
    dependencies.rebind(repository).toConstantValue(new implementation());
  } else {
    dependencies.bind(repository).toConstantValue(new implementation());
  }
}

function injectRepositories() {
  injectRepository(Repositories.gym, MongoGymRepository);
  injectRepository(Repositories.user, MongoUserRepository);
  injectRepository(Repositories.auth, CognitoAuthRepository);
  injectRepository(Repositories.relationship, MongoRelationshipRepository);
  injectRepository(Repositories.location, OSMLocationRepository);
  injectRepository(
    Repositories.directConversation,
    MongoDirectConversationRepository
  );
  injectRepository(Repositories.directMessage, MongoDirectMessageRepository);
}

export function injectUseCases() {
  injectUseCase(UseCases.getGym, GetGymUseCase);
  injectUseCase(UseCases.getNearestGyms, GetNearestGymsUseCase);
  injectUseCase(UseCases.authenticate, AuthenticateUseCase);
  injectUseCase(UseCases.getUser, GetUserUseCase);
  injectUseCase(UseCases.explore, ExploreUseCase);
  injectUseCase(UseCases.createGym, CreateGymUseCase);
  injectUseCase(UseCases.forgotPasswordSubmit, ForgotPasswordSubmitUseCase);
  injectUseCase(
    UseCases.getReceivedFriendRequests,
    GetReceivedFriendRequestsUseCase
  );
  injectUseCase(UseCases.login, LoginUseCase);
  injectUseCase(UseCases.getSentFriendRequests, GetSentFriendRequestsUseCase);
  injectUseCase(UseCases.register, RegisterUseCase);
  injectUseCase(UseCases.confirmRegister, ConfirmRegisterUseCase);
  injectUseCase(UseCases.refreshSession, RefreshSessionUseCase);
  injectUseCase(UseCases.resendConfirmation, ResendConfirmationUseCase);
  injectUseCase(UseCases.forgotPassword, ForgotPasswordUseCase);
  injectUseCase(UseCases.signOut, SignOutUseCase);
  injectUseCase(UseCases.sendFriendRequest, SendFriendRequestUseCase);
  injectUseCase(UseCases.block, BlockUseCase);
  injectUseCase(UseCases.unblock, UnblockUseCase);
  injectUseCase(UseCases.denyFriendRequest, DenyFriendRequestUseCase);
  injectUseCase(UseCases.getFriends, GetFriendsUseCase);
  injectUseCase(UseCases.sendDirectMessage, SendDirectMessageUseCase);
  injectUseCase(UseCases.tutorialExplore, TutorialExploreUseCase);
  injectUseCase(
    UseCases.getRecentDirectConversations,
    GetRecentDirectConversationsUseCase
  );
}

export function injectAdapters() {
  injectController(Controllers.gym, GymController);
  injectController(Controllers.user, UserController);
  injectController(Controllers.auth, AuthController);
  injectController(Middlewares.authenticate, AuthMiddleware);
  injectController(Controllers.relationship, RelationshipController);
  injectController(
    Controllers.directConversation,
    DirectConversationController
  );
}

export function injectEventHandlers() {
  injectEventHandler(EventHandlers.onConnect, OnConnectEventHandler);
  injectEventHandler(EventHandlers.onDisconnect, OnDisconnectEventHandler);
  injectEventHandler(
    EventHandlers.sendDirectMessage,
    SendDirectMessageEventHandler
  );
  injectEventHandler(
    EventHandlers.sendFriendRequest,
    SendFriendRequestEventHandler
  );
}

export function injectUseCase<Type extends IUseCase>(
  useCase: symbol,
  implementation: interfaces.Newable<Type>
) {
  if (dependencies.isBound(useCase)) {
    dependencies.rebind(useCase).to(implementation);
  } else {
    dependencies.bind(useCase).to(implementation);
  }
}

export function injectController<Type>(
  controller: symbol,
  implementation: interfaces.Newable<Type>
) {
  if (dependencies.isBound(controller)) {
    dependencies.rebind(controller).to(implementation);
  } else {
    dependencies.bind(controller).to(implementation);
  }
}

export function injectEventHandler<Type extends IEventHandler>(
  eventHandler: symbol,
  implementation: interfaces.Newable<Type>
) {
  if (dependencies.isBound(eventHandler)) {
    dependencies.rebind(eventHandler).to(implementation);
  } else {
    dependencies.bind(eventHandler).to(implementation);
  }
}

export function unbind() {
  dependencies.unbindAll();
}

export function injectDependencies() {
  dependencies = new Container({
    defaultScope: "Singleton",
    autoBindInjectable: true,
  });

  injectRepositories();
  injectUseCases();
  injectAdapters();
  injectEventHandlers();

  l.info(`All dependencies have been injected`);
}
