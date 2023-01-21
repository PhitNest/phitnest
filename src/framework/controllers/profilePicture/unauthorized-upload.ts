import { IRequest, IResponse } from "../../../common/types";
import { z } from "zod";
import { Controller, HttpMethod } from "../types";
import { unauthorizedProfilePictureUploadUrl } from "../../../domain/use-cases";

const unauthorizedUploadValidator = z.object({
  email: z.string().trim(),
  password: z.string(),
});

type UnauthorizedProfilePictureUploadRequest = z.infer<
  typeof unauthorizedUploadValidator
>;

export class UnauthorizedProfilePictureUploadController
  implements
    Controller<
      UnauthorizedProfilePictureUploadRequest,
      {
        url: string;
      }
    >
{
  method = HttpMethod.GET;

  validate(body: any) {
    return unauthorizedUploadValidator.parse(body);
  }

  execute(
    req: IRequest<UnauthorizedProfilePictureUploadRequest>,
    res: IResponse<{
      url: string;
    }>
  ) {
    return unauthorizedProfilePictureUploadUrl(
      req.body.email,
      req.body.password
    );
  }
}
