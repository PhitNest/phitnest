import express from "express";
import { buildRouter } from "./drivers/express";
import { MongoUserRepository } from "./adapters/repositories/implementations";
import {
  IAuthenticationRepository,
  IGymRepository,
  IUserRepository,
} from "./adapters/repositories/interfaces";
import {
  AuthenticationUseCase,
  buildAuthenticationUseCase,
  buildGetGymUseCase,
  buildGetNearestGymsUseCase,
  GetGymUseCase,
  GetNearestGymsUseCase,
} from "./domain/use-cases";
import {
  buildAuthenticationMiddleware,
  buildGetGymController,
  buildGetNearestGymsController,
  Controller,
  Middleware,
} from "./adapters/controllers";
import l from "./common/logger";
import { CognitoAuthenticationRepository } from "./adapters/repositories/implementations/authentication.repository";
import { MongoGymRepository } from "./adapters/repositories/implementations/gym.repository";

export type Repositories = {
  gymRepository: IGymRepository;
  userRepository: IUserRepository;
  authenticationRepository: IAuthenticationRepository;
};

export type UseCases = {
  getNearestGymsUseCase: GetNearestGymsUseCase;
  getGymUseCase: GetGymUseCase;
  authenticationUseCase: AuthenticationUseCase;
};

export type Controllers = {
  getNearestGymsController: Controller;
  getGymController: Controller;
  authenticationMiddleware: Middleware;
};

/**
 * Injects all dependencies in order to build the router
 */
export function injectDependencies(
  app: express.Express,
  mockRepositories?: Partial<Repositories>,
  mockUseCases?: Partial<UseCases>,
  mockControllers?: Partial<Controllers>
) {
  const repositories = buildRepositories();
  const useCases = buildUseCases({ ...repositories, ...mockRepositories });
  const controllers = buildControllers({ ...useCases, ...mockUseCases });
  app.use(buildRouter({ ...controllers, ...mockControllers }));
  l.info("Injected all dependencies");
}

function buildRepositories(): Repositories {
  return {
    gymRepository: new MongoGymRepository(),
    userRepository: new MongoUserRepository(),
    authenticationRepository: new CognitoAuthenticationRepository(),
  };
}

function buildUseCases(repositories: Repositories): UseCases {
  return {
    getNearestGymsUseCase: buildGetNearestGymsUseCase(
      repositories.gymRepository
    ),
    getGymUseCase: buildGetGymUseCase(repositories.userRepository),
    authenticationUseCase: buildAuthenticationUseCase(
      repositories.authenticationRepository
    ),
  };
}

function buildControllers(useCases: UseCases): Controllers {
  return {
    getNearestGymsController: buildGetNearestGymsController(
      useCases.getNearestGymsUseCase
    ),
    getGymController: buildGetGymController(useCases.getGymUseCase),
    authenticationMiddleware: buildAuthenticationMiddleware(
      useCases.authenticationUseCase
    ),
  };
}
