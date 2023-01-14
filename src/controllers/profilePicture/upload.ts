import {
  AuthenticatedLocals,
  Failure,
  IRequest,
  IResponse,
} from "../../common/types";
import { Controller, HttpMethod } from "../types";
import { authMiddleware } from "../../middleware";
import repositories from "../../repositories/injection";

export class ProfilePictureUploadController
  implements
    Controller<
      {},
      {
        url: string;
      },
      AuthenticatedLocals
    >
{
  method = HttpMethod.GET;

  middleware = [authMiddleware];

  validate(body: any) {
    return {};
  }

  async execute(
    req: IRequest<{}>,
    res: IResponse<
      {
        url: string;
      },
      AuthenticatedLocals
    >
  ) {
    const { profilePictureRepo } = repositories();
    const pfp = await profilePictureRepo.getProfilePictureUploadUrl(
      res.locals.cognitoId
    );
    if (pfp instanceof Failure) {
      return pfp;
    } else {
      return {
        url: pfp,
      };
    }
  }
}
