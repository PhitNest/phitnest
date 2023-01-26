import { Failure, IRequest, IResponse } from "../../common/types";
import { authRepo } from "../../domain/repositories";

export async function authMiddleware(
  req: IRequest<any>,
  res: IResponse<any>,
  next: (failure?: Failure) => void
) {
  const cognitoId = await authRepo.getCognitoId(req.authorization);
  if (cognitoId instanceof Failure) {
    next(cognitoId);
  } else {
    res.setLocals({
      cognitoId: cognitoId,
    });
    next();
  }
}
