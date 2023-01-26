import {
  AuthenticatedLocals,
  Failure,
  IRequest,
  IResponse,
} from "../../../common/types";
import { Controller, HttpMethod } from "../types";
import { authMiddleware } from "../../middleware";
import { profilePictureRepo } from "../../../domain/repositories";

type ProfilePictureUploadResponse = {
  url: string;
};

export class ProfilePictureUploadController
  implements Controller<ProfilePictureUploadResponse>
{
  method = HttpMethod.GET;

  route = "/profilePicture/upload";

  middleware = [authMiddleware];

  async execute(
    req: IRequest,
    res: IResponse<ProfilePictureUploadResponse, AuthenticatedLocals>
  ) {
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
