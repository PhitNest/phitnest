import { inject, injectable } from "inversify";
import { z } from "zod";
import { UseCases } from "../../../common/dependency-injection";
import {
  IExploreUseCase,
  IGetProfilePictureUseCase,
  IGetUserUseCase,
  ITutorialExploreUseCase,
} from "../../../use-cases/interfaces";
import { IResponse, IRequest, IAuthenticatedResponse } from "../../types";
import { IUserController } from "../interfaces";
import {
  statusInternalServerError,
  statusOK,
} from "../../../constants/http_codes";
import {
  IProfilePictureExploreUserEntity,
  IProfilePictureUserEntity,
} from "../../../entities";

@injectable()
export class UserController implements IUserController {
  getUserUseCase: IGetUserUseCase;
  exploreUseCase: IExploreUseCase;
  tutorialExploreUseCase: ITutorialExploreUseCase;
  getProfilePictureUseCase: IGetProfilePictureUseCase;

  constructor(
    @inject(UseCases.getUser) getUserUseCase: IGetUserUseCase,
    @inject(UseCases.explore) exploreUseCase: IExploreUseCase,
    @inject(UseCases.tutorialExplore)
    tutorialExploreUseCase: ITutorialExploreUseCase,
    @inject(UseCases.getProfilePicture)
    getProfilePictureUseCase: IGetProfilePictureUseCase
  ) {
    this.getUserUseCase = getUserUseCase;
    this.exploreUseCase = exploreUseCase;
    this.tutorialExploreUseCase = tutorialExploreUseCase;
    this.getProfilePictureUseCase = getProfilePictureUseCase;
  }

  async explore(
    req: IRequest,
    res: IAuthenticatedResponse<IProfilePictureExploreUserEntity[]>
  ) {
    try {
      const { skip, limit } = z
        .object({
          skip: z.number().min(0).optional(),
          limit: z.number().min(0).max(100).optional(),
        })
        .parse(req.content());
      const users = await this.exploreUseCase.execute(
        res.locals.cognitoId,
        skip,
        limit
      );
      return res.status(statusOK).json(users);
    } catch (err) {
      return res.status(statusInternalServerError).send(err);
    }
  }

  async getProfilePictureUploadUrl(
    req: IRequest,
    res: IAuthenticatedResponse<{ uploadProfilePicture: string }>
  ) {
    try {
      return res.status(statusOK).json({
        uploadProfilePicture: await this.getProfilePictureUseCase.execute(
          res.locals.cognitoId
        ),
      });
    } catch (err) {
      return res.status(statusInternalServerError).send(err);
    }
  }

  async tutorialExplore(
    req: IRequest,
    res: IResponse<IProfilePictureExploreUserEntity[]>
  ) {
    try {
      const { gymId, skip, limit } = z
        .object({
          gymId: z.string(),
          skip: z.number().min(0).optional(),
          limit: z.number().min(0).max(100).optional(),
        })
        .parse(req.content());
      const users = await this.tutorialExploreUseCase.execute(
        gymId,
        skip,
        limit
      );
      return res.status(statusOK).json(
        await Promise.all(
          users.map(async (user) => ({
            _id: user._id,
            firstName: user.firstName,
            lastName: user.lastName,
            cognitoId: user.cognitoId,
            profilePicture: await this.getProfilePictureUseCase.execute(
              user.cognitoId
            ),
          }))
        )
      );
    } catch (err) {
      return res.status(statusInternalServerError).send(err);
    }
  }

  async get(
    req: IRequest,
    res: IAuthenticatedResponse<IProfilePictureUserEntity>
  ) {
    try {
      const user = await this.getUserUseCase.execute(res.locals.cognitoId);
      if (user) {
        return res.status(statusOK).json({
          _id: user._id,
          firstName: user.firstName,
          lastName: user.lastName,
          email: user.email,
          cognitoId: user.cognitoId,
          gymId: user.gymId,
          profilePicture: await this.getProfilePictureUseCase.execute(
            user.cognitoId
          ),
        });
      } else {
        return res.status(statusInternalServerError).send({
          code: "InvalidCognitoId",
          message: "Could not find a user",
        });
      }
    } catch (err) {
      return res.status(statusInternalServerError).send(err);
    }
  }
}
