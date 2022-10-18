import { Request, Response } from "express";
import UserQueries from "../../queries/user.queries";

function respondWithTokens(req: Request, res: Response) {
  return res.status(200).json({
    accessToken: res.locals.cognitoSession.getAccessToken().getJwtToken(),
    refreshToken: res.locals.cognitoSession.getRefreshToken().getToken(),
    idToken: res.locals.cognitoSession.getIdToken().getJwtToken(),
  });
}

class AuthController {
  login(req: Request, res: Response) {
    return respondWithTokens(req, res);
  }

  refreshSession(req: Request, res: Response) {
    return respondWithTokens(req, res);
  }

  async register(req: Request, res: Response) {
    await UserQueries.createUser(
      res.locals.userId,
      req.body.email,
      req.body.firstName,
      req.body.lastName
    );
    return res.status(200).send("SUCCESS");
  }

  confirmRegister(req: Request, res: Response) {
    return res.status(200).send("SUCCESS");
  }

  isAuthenticated(req: Request, res: Response) {
    return res.status(200).send("SUCCESS");
  }

  resendConfirmationCode(req: Request, res: Response) {
    return res.status(200).send("SUCCESS");
  }

  signOut(req: Request, res: Response) {
    return res.status(200).send("SUCCESS");
  }
}

export default new AuthController();
