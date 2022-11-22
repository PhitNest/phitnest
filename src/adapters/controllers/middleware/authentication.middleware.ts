import { AuthenticationUseCase } from "../../../domain/use-cases";
import { Middleware } from "../middleware";

export function buildAuthenticationMiddleware(
  authenticate: AuthenticationUseCase
): Middleware<{ userId: string | undefined }> {
  return async function (req, res, next) {
    const userId = await authenticate(
      req.authorization().replace("Bearer ", "")
    );
    if (userId) {
      res.locals.userId = userId;
      next();
    } else {
      next("You are not authenticated");
    }
  };
}
