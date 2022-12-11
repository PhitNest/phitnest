import { inject, injectable } from "inversify";
import { z } from "zod";
import { UseCases } from "../../../common/dependency-injection";
import {
  IExploreUseCase,
  IGetUserUseCase,
  ITutorialExploreUseCase,
} from "../../../use-cases/interfaces";
import { IResponse, AuthenticatedLocals, IRequest } from "../../types";
import { IUserController } from "../interfaces";
import {
  statusBadRequest,
  statusInternalServerError,
  statusOK,
} from "../../../constants/status_codes";

@injectable()
export class UserController implements IUserController {
  getUserUseCase: IGetUserUseCase;
  exploreUseCase: IExploreUseCase;
  tutorialExploreUseCase: ITutorialExploreUseCase;

  constructor(
    @inject(UseCases.getUser) getUserUseCase: IGetUserUseCase,
    @inject(UseCases.explore) exploreUseCase: IExploreUseCase,
    @inject(UseCases.tutorialExplore)
    tutorialExploreUseCase: ITutorialExploreUseCase
  ) {
    this.getUserUseCase = getUserUseCase;
    this.exploreUseCase = exploreUseCase;
    this.tutorialExploreUseCase = tutorialExploreUseCase;
  }

  async explore(req: IRequest, res: IResponse<AuthenticatedLocals>) {
    try {
      const { skip, limit } = z
        .object({
          skip: z.number().min(0).optional(),
          limit: z.number().min(0).max(100).optional(),
        })
        .parse(req.content());
      const users = await this.exploreUseCase.execute(
        res.locals.cognitoId,
        skip,
        limit
      );
      return res.status(statusOK).json(users);
    } catch (err) {
      if (err instanceof z.ZodError) {
        return res.status(statusBadRequest).json(err.issues);
      } else if (err instanceof Error) {
        return res.status(statusInternalServerError).json(err.message);
      } else {
        return res.status(statusInternalServerError).send(err);
      }
    }
  }

  async tutorialExplore(req: IRequest, res: IResponse) {
    try {
      const { gymId, skip, limit } = z
        .object({
          gymId: z.string(),
          skip: z.number().min(0).optional(),
          limit: z.number().min(0).max(100).optional(),
        })
        .parse(req.content());
      const users = await this.tutorialExploreUseCase.execute(
        gymId,
        skip,
        limit
      );
      return res.status(statusOK).json(users);
    } catch (err) {
      if (err instanceof z.ZodError) {
        return res.status(statusBadRequest).json(err.issues);
      }
      if (err instanceof Error) {
        return res.status(statusInternalServerError).json(err.message);
      } else {
        return res.status(statusInternalServerError).send(err);
      }
    }
  }

  async get(req: IRequest, res: IResponse<AuthenticatedLocals>) {
    try {
      const user = await this.getUserUseCase.execute(res.locals.cognitoId);
      if (user) {
        return res.status(statusOK).json(user);
      } else {
        return res
          .status(statusInternalServerError)
          .json({ message: "Could not find a user" });
      }
    } catch (err) {
      if (err instanceof Error) {
        return res.status(statusInternalServerError).json(err.message);
      } else {
        return res.status(statusInternalServerError).send(err);
      }
    }
  }
}
