import { IRequest, IResponse } from "../../../common/types";
import { z } from "zod";
import { Controller, HttpMethod } from "../types";
import { unauthorizedProfilePictureUploadUrl } from "../../../domain/use-cases";

type UnauthorizedProfilePictureUploadResponse = {
  url: string;
};

export class UnauthorizedProfilePictureUploadController
  implements Controller<UnauthorizedProfilePictureUploadResponse>
{
  method = HttpMethod.GET;

  route = "/profilePicture/unauthorized";

  validator = z.object({
    email: z.string().trim(),
    password: z.string(),
  });

  execute(
    req: IRequest<z.infer<typeof this.validator>>,
    res: IResponse<UnauthorizedProfilePictureUploadResponse>
  ) {
    return unauthorizedProfilePictureUploadUrl(
      req.body.email,
      req.body.password
    );
  }
}
