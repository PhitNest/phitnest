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
};

export const Controllers = {
  gymController: Symbol("gym.controller"),
  authenticate: Symbol("authenticate.middleware"),
  user: Symbol("user.controller"),
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
} from "../use-cases/interfaces";

import {
  GetGymUseCase,
  GetNearestGymsUseCase,
  AuthenticateUseCase,
  GetUserUseCase,
  ExploreUseCase,
  CreateGymUseCase,
} from "../use-cases/implementations";

import { IAuthMiddleware } from "../adapters/middleware/interfaces";

import { AuthMiddleware } from "../adapters/middleware/implementations";

import {
  IGymController,
  IUserController,
} from "../adapters/controllers/interfaces";

import {
  GymController,
  UserController,
} from "../adapters/controllers/implementations";

import { l } from "./logger";

export let dependencies: Container;

export function unbind() {
  dependencies.unbindAll();
}

export function inject() {
  dependencies = new Container({
    defaultScope: "Singleton",
    autoBindInjectable: true,
  });
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

  dependencies.bind<IGetGymUseCase>(UseCases.getGym).to(GetGymUseCase);
  dependencies
    .bind<IGetNearestGymsUseCase>(UseCases.getNearestGyms)
    .to(GetNearestGymsUseCase);
  dependencies
    .bind<IAuthenticateUseCase>(UseCases.authenticate)
    .to(AuthenticateUseCase);
  dependencies.bind<IGetUserUseCase>(Controllers.user).to(GetUserUseCase);
  dependencies.bind<IExploreUseCase>(UseCases.explore).to(ExploreUseCase);
  dependencies.bind<ICreateGymUseCase>(UseCases.createGym).to(CreateGymUseCase);

  dependencies.bind<IUserController>(Controllers.user).to(UserController);
  dependencies
    .bind<IAuthMiddleware>(Controllers.authenticate)
    .to(AuthMiddleware);
  dependencies
    .bind<IGymController>(Controllers.gymController)
    .to(GymController);

  l.info(`All dependencies have been injected`);
}
