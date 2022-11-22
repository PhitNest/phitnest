import { AuthenticationUseCase } from "../../../domain/use-cases";
import { Middleware } from "../middleware";

export function buildAuthenticationMiddleware(
  authenticate: AuthenticationUseCase
): Middleware {
  return async function (req, res, next) {
    res.locals.userId = authenticate(req.authorization());
    if (res.locals.userId) {
      next();
    } else {
      next("You are not authenticated");
    }
  };
}
