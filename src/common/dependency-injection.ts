import "reflect-metadata";
import { Container } from "inversify";

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
  createGym: Symbol("createGym.use-case"),
  login: Symbol("login.use-case"),
  register: Symbol("register.use-case"),
  confirmRegister: Symbol("confirmRegister.use-case"),
  refreshSession: Symbol("refreshSession.use-case"),
  resendConfirmation: Symbol("resendConfirmation.use-case"),
};

export const Middlewares = {
  authenticate: Symbol("authenticate.middleware"),
};

export const Controllers = {
  gym: Symbol("gym.controller"),
  user: Symbol("user.controller"),
  auth: Symbol("auth.controller"),
};

// Make sure to export repositories, use cases, and controllers symbols before importing the following

import {
  IAuthRepository,
  IGymRepository,
  IUserRepository,
  IRelationshipRepository,
  ILocationRepository,
} from "../repositories/interfaces";

import {
  MongoUserRepository,
  CognitoAuthRepository,
  MongoGymRepository,
  MongoRelationshipRepository,
  OSMLocationRepository,
} from "../repositories/implementations";

import {
  IGetGymUseCase,
  IGetNearestGymsUseCase,
  IAuthenticateUseCase,
  IGetUserUseCase,
  IExploreUseCase,
  ICreateGymUseCase,
  ILoginUseCase,
  IRegisterUseCase,
  IConfirmRegisterUseCase,
  IResendConfirmationUseCase,
  IRefreshSessionUseCase,
} from "../use-cases/interfaces";

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
} from "../use-cases/implementations";

import { IAuthMiddleware } from "../adapters/middleware/interfaces";

import { AuthMiddleware } from "../adapters/middleware/implementations";

import {
  IGymController,
  IUserController,
  IAuthController,
} from "../adapters/controllers/interfaces";

import {
  GymController,
  UserController,
  AuthController,
} from "../adapters/controllers/implementations";

import { l } from "./logger";

export let dependencies: Container;

function injectRepositories() {
  dependencies
    .bind<IGymRepository>(Repositories.gym)
    .toConstantValue(new MongoGymRepository());
  dependencies
    .bind<IAuthRepository>(Repositories.auth)
    .toConstantValue(new CognitoAuthRepository());
  dependencies
    .bind<IUserRepository>(Repositories.user)
    .toConstantValue(new MongoUserRepository());
  dependencies
    .bind<IRelationshipRepository>(Repositories.relationship)
    .toConstantValue(new MongoRelationshipRepository());
  dependencies
    .bind<ILocationRepository>(Repositories.location)
    .toConstantValue(new OSMLocationRepository());
}

function injectUseCases() {
  dependencies.bind<IGetGymUseCase>(UseCases.getGym).to(GetGymUseCase);
  dependencies
    .bind<IGetNearestGymsUseCase>(UseCases.getNearestGyms)
    .to(GetNearestGymsUseCase);
  dependencies
    .bind<IAuthenticateUseCase>(UseCases.authenticate)
    .to(AuthenticateUseCase);
  dependencies.bind<IGetUserUseCase>(UseCases.getUser).to(GetUserUseCase);
  dependencies.bind<IExploreUseCase>(UseCases.explore).to(ExploreUseCase);
  dependencies.bind<ICreateGymUseCase>(UseCases.createGym).to(CreateGymUseCase);
  dependencies.bind<ILoginUseCase>(UseCases.login).to(LoginUseCase);
  dependencies.bind<IRegisterUseCase>(UseCases.register).to(RegisterUseCase);
  dependencies
    .bind<IConfirmRegisterUseCase>(UseCases.confirmRegister)
    .to(ConfirmRegisterUseCase);
  dependencies
    .bind<IRefreshSessionUseCase>(UseCases.refreshSession)
    .to(RefreshSessionUseCase);
  dependencies
    .bind<IResendConfirmationUseCase>(UseCases.resendConfirmation)
    .to(ResendConfirmationUseCase);
}

function injectControllers() {
  dependencies.bind<IUserController>(Controllers.user).to(UserController);
  dependencies
    .bind<IAuthMiddleware>(Middlewares.authenticate)
    .to(AuthMiddleware);
  dependencies.bind<IGymController>(Controllers.gym).to(GymController);
  dependencies.bind<IAuthController>(Controllers.auth).to(AuthController);
}

export function unbind() {
  dependencies.unbindAll();
}

export function rebindUseCases() {
  for (let i = 0; i < Object.keys(UseCases).length; i++) {
    dependencies.unbind(Object.values(UseCases)[i]);
  }
  injectUseCases();
}

export function rebindControllers() {
  for (let i = 0; i < Object.keys(Controllers).length; i++) {
    dependencies.unbind(Object.values(Controllers)[i]);
  }
  for (let i = 0; i < Object.keys(Middlewares).length; i++) {
    dependencies.unbind(Object.values(Middlewares)[i]);
  }
  injectControllers();
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
