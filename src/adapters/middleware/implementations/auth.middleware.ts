import { inject, injectable } from "inversify";
import { UseCases } from "../../../common/dependency-injection";
import { IAuthenticateUseCase } from "../../../use-cases/interfaces";
import { IRequest, IResponse } from "../../types";
import { IAuthMiddleware } from "../interfaces";

@injectable()
export class AuthMiddleware implements IAuthMiddleware {
  authenticateUseCase: IAuthenticateUseCase;

  constructor(
    @inject(UseCases.authenticate) authenticate: IAuthenticateUseCase
  ) {
    this.authenticateUseCase = authenticate;
  }

  async execute(
    req: IRequest,
    res: IResponse<{ userId: string | undefined }>,
    next: (err?: string) => void
  ) {
    if (req.authorization()) {
      try {
        const userId = await this.authenticateUseCase.execute(
          req.authorization()!.replace("Bearer ", "")
        );
        if (userId) {
          res.locals.userId = userId;
          return next();
        }
      } catch (err: any) {
        if (err instanceof Error) {
          return next(err.message);
        }
      }
    }
    return next("You are not authenticated");
  }
}
