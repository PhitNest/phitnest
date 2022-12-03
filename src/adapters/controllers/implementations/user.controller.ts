import { inject, injectable } from "inversify";
import { z } from "zod";
import { UseCases } from "../../../common/dependency-injection";
import {
  IExploreUseCase,
  IGetUserUseCase,
} from "../../../use-cases/interfaces";
import { IResponse, AuthenticatedLocals, IRequest } from "../../types";
import { IUserController } from "../interfaces";

@injectable()
export class UserController implements IUserController {
  getUserUseCase: IGetUserUseCase;
  exploreUseCase: IExploreUseCase;

  constructor(
    @inject(UseCases.getUser) getUserUseCase: IGetUserUseCase,
    @inject(UseCases.explore) exploreUseCase: IExploreUseCase
  ) {
    this.getUserUseCase = getUserUseCase;
    this.exploreUseCase = exploreUseCase;
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
      return res.status(200).json(users);
    } catch (err) {
      return res.status(500).json(err);
    }
  }

  async get(req: IRequest, res: IResponse<AuthenticatedLocals>) {
    try {
      const user = await this.getUserUseCase.execute(res.locals.cognitoId);
      if (user) {
        return res.status(200).json(user);
      } else {
        return res.status(500).json({ message: "Could not find a user" });
      }
    } catch (err) {
      return res.status(500).json(err);
    }
  }
}
