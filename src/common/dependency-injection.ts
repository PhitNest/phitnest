import "reflect-metadata";
import { Container, interfaces } from "inversify";

export const Repositories = {
  user: Symbol("user.repository"),
  auth: Symbol("auth.repository"),
  gym: Symbol("gym.repository"),
  relationship: Symbol("relationship.repository"),
  location: Symbol("location.repository"),
};

export const UseCases = {
  getGym: Symbol("getGym.use-case"),
  getNearestGyms: Symbol("getNearestGyms.use-case"),
  authenticate: Symbol("authenticate.use-case"),
  getUser: Symbol("getUser.use-case"),
  explore: Symbol("explore.use-case"),
  forgotPasswordSubmit: Symbol("forgotPasswordSubmit.use-case"),
  createGym: Symbol("createGym.use-case"),
  login: Symbol("login.use-case"),
  register: Symbol("register.use-case"),
  confirmRegister: Symbol("confirmRegister.use-case"),
  refreshSession: Symbol("refreshSession.use-case"),
  resendConfirmation: Symbol("resendConfirmation.use-case"),
  forgotPassword: Symbol("forgotPassword.use-case"),
  signOut: Symbol("signOut.use-case"),
  sendFriendRequest: Symbol("sendFriendRequest.use-case"),
};

export const Middlewares = {
  authenticate: Symbol("authenticate.middleware"),
};

export const Controllers = {
  gym: Symbol("gym.controller"),
  user: Symbol("user.controller"),
  auth: Symbol("auth.controller"),
  relationship: Symbol("relationship.controller"),
};

// Make sure to export repositories, use cases, and controllers symbols before importing the following

import {
  MongoUserRepository,
  CognitoAuthRepository,
  MongoGymRepository,
  MongoRelationshipRepository,
  OSMLocationRepository,
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
} from "../use-cases/implementations";

import { AuthMiddleware } from "../adapters/middleware/implementations";

import {
  GymController,
  UserController,
  AuthController,
  RelationshipController,
} from "../adapters/controllers/implementations";

import { l } from "./logger";

import { IUseCase } from "../use-cases/types";

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

function injectUseCase<Type extends IUseCase>(
  useCase: symbol,
  implementation: interfaces.Newable<Type>
) {
  if (dependencies.isBound(useCase)) {
    dependencies.rebind(useCase).to(implementation);
  } else {
    dependencies.bind(useCase).to(implementation);
  }
}

function injectController<Type>(
  controller: symbol,
  implementation: interfaces.Newable<Type>
) {
  if (dependencies.isBound(controller)) {
    dependencies.rebind(controller).to(implementation);
  } else {
    dependencies.bind(controller).to(implementation);
  }
}

function injectRepositories() {
  injectRepository(Repositories.gym, MongoGymRepository);
  injectRepository(Repositories.user, MongoUserRepository);
  injectRepository(Repositories.auth, CognitoAuthRepository);
  injectRepository(Repositories.relationship, MongoRelationshipRepository);
  injectRepository(Repositories.location, OSMLocationRepository);
}

export function injectUseCases() {
  injectUseCase(UseCases.getGym, GetGymUseCase);
  injectUseCase(UseCases.getNearestGyms, GetNearestGymsUseCase);
  injectUseCase(UseCases.authenticate, AuthenticateUseCase);
  injectUseCase(UseCases.getUser, GetUserUseCase);
  injectUseCase(UseCases.explore, ExploreUseCase);
  injectUseCase(UseCases.createGym, CreateGymUseCase);
  injectUseCase(UseCases.forgotPasswordSubmit, ForgotPasswordSubmitUseCase);
  injectUseCase(UseCases.login, LoginUseCase);
  injectUseCase(UseCases.register, RegisterUseCase);
  injectUseCase(UseCases.confirmRegister, ConfirmRegisterUseCase);
  injectUseCase(UseCases.refreshSession, RefreshSessionUseCase);
  injectUseCase(UseCases.resendConfirmation, ResendConfirmationUseCase);
  injectUseCase(UseCases.forgotPassword, ForgotPasswordUseCase);
  injectUseCase(UseCases.signOut, SignOutUseCase);
  injectUseCase(UseCases.sendFriendRequest, SendFriendRequestUseCase);
}

export function injectControllers() {
  injectController(Controllers.gym, GymController);
  injectController(Controllers.user, UserController);
  injectController(Controllers.auth, AuthController);
  injectController(Middlewares.authenticate, AuthMiddleware);
  injectController(Controllers.relationship, RelationshipController);
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
  injectControllers();

  l.info(`All dependencies have been injected`);
}
