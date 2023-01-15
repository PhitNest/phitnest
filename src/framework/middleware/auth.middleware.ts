import { Failure } from "../../common/types";
import { authRepo } from "../../domain/repositories";
import { Middleware } from "./types";

export const authMiddleware: Middleware<any, any, any> = async (
  req,
  res,
  next
) => {
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
