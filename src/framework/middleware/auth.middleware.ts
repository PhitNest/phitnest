import { Failure, IRequest, IResponse } from "../../common/types";
import { databases().authDatabase } from "../../domain/repositories";

export async function authMiddleware(
  req: IRequest<any>,
  res: IResponse<any>,
  next: (failure?: Failure) => void
) {
  const cognitoId = await databases().authDatabase.getCognitoId(req.authorization);
  if (cognitoId instanceof Failure) {
    next(cognitoId);
  } else {
    res.setLocals({
      cognitoId: cognitoId,
    });
    next();
  }
}
