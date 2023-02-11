import {
  AuthenticatedLocals,
  Failure,
  IRequest,
  IResponse,
} from "../../../common/types";
import { Controller, HttpMethod } from "../types";
import { authMiddleware } from "../../middleware";
import databases from "../../../data/data-sources/injection";

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
    const pfp =
      await databases().profilePictureDatabase.getProfilePictureUploadUrl(
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
