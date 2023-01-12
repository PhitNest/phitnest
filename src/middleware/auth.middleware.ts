import { Failure } from "../common/types";
import repositories from "../repositories/injection";
import { Middleware } from "./types";

export const authMiddleware: Middleware<any, any, any> = async (
  req,
  res,
  next
) => {
  const { authRepo } = repositories();
  const cognitoId = await authRepo.getCognitoId(req.authorization);
  if (cognitoId instanceof Failure) {
    next(cognitoId);
  } else {
    res.setLocals({
      cognitoId: cognitoId,
    });
    next();
  }
};
