import express from "express";
import { buildRouter } from "./drivers/express";
import { MongoUserRepository } from "./adapters/repositories/implementations";
import {
  IAuthenticationRepository,
  IUserRepository,
} from "./adapters/repositories/interfaces";
import {
  AuthenticationUseCase,
  buildAuthenticationUseCase,
  buildGetGymUseCase,
  GetGymUseCase,
} from "./domain/use-cases";
import {
  buildAuthenticationMiddleware,
  buildGetGymController,
  Controller,
  Middleware,
} from "./adapters/controllers";
import l from "./common/logger";

type Repositories = {
  userRepository: IUserRepository;
  authenticationRepository: IAuthenticationRepository;
};

type UseCases = {
  getGymUseCase: GetGymUseCase;
  authenticationUseCase: AuthenticationUseCase;
};

type Controllers = {
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
  l.info("Injected all dependencies.");
}

function buildRepositories(): Repositories {
  return {
    userRepository: new MongoUserRepository(),
    authenticationRepository: {
      authenticate: async (accessToken) => {
        return "test";
      },
    } as IAuthenticationRepository,
  };
}

function buildUseCases(repositories: Repositories): UseCases {
  return {
    getGymUseCase: buildGetGymUseCase(repositories.userRepository),
    authenticationUseCase: buildAuthenticationUseCase(
      repositories.authenticationRepository
    ),
  };
}

function buildControllers(useCases: UseCases): Controllers {
  return {
    getGymController: buildGetGymController(useCases.getGymUseCase),
    authenticationMiddleware: buildAuthenticationMiddleware(
      useCases.authenticationUseCase
    ),
  };
}
