import express from "express";
import http from "http";
import { Either } from "typescript-monads";
import { Failure, HttpMethod, IRequest, IResponse } from "../../common/types";
import { Controller } from "../../controllers/types";
import { Validator } from "../../validators/types";
import { Middleware } from "../../middleware/types";
import { IServer } from "../interfaces";
import bodyParser from "body-parser";
import morgan from "morgan";

class ExpressRequest<BodyType> implements IRequest<BodyType> {
  expressRequest: express.Request;
  body: BodyType;
  authorization: string;

  constructor(expressRequest: express.Request) {
    this.expressRequest = expressRequest;
    this.body = {
      ...expressRequest.body,
      ...expressRequest.query,
      ...expressRequest.params,
    };
    this.authorization = expressRequest.headers.authorization ?? "";
  }
}

class ExpressResponse<ResType, LocalsType>
  implements IResponse<ResType, LocalsType>
{
  expressResponse: express.Response;
  locals: LocalsType;

  constructor(expressResponse: express.Response) {
    this.expressResponse = expressResponse;
    this.locals = this.expressResponse.locals as LocalsType;
  }

  status(status: number) {
    this.expressResponse.status(status);
    return new ExpressResponse<ResType, LocalsType>(this.expressResponse);
  }

  json(body: Either<ResType, Failure>) {
    this.expressResponse.json(
      body.match({ left: (x) => x as ResType | Failure, right: (x) => x })
    );
    return new ExpressResponse<ResType, LocalsType>(this.expressResponse);
  }

  setLocals<NewLocals>(newLocals: NewLocals) {
    this.expressResponse.locals = newLocals as Record<string, any>;
    return new ExpressResponse<ResType, NewLocals>(this.expressResponse);
  }
}

export class ExpressServer implements IServer {
  expressApp: express.Application;
  server: http.Server | undefined;

  constructor() {
    this.expressApp = express();
    this.expressApp.use(bodyParser.json());
    this.expressApp.use(morgan("dev"));
    this.expressApp.get("/", (req, res) => res.status(200).send());
  }

  listen(port: number) {
    this.server = http.createServer(this.expressApp);
    return new Promise<void>((resolve) =>
      this.server!.listen(port, () => {
        console.log(`Server listening on port ${port}`);
        resolve();
      })
    );
  }

  close() {
    if (this.server) {
      return new Promise<void>((resolve) =>
        this.server!.close(() => {
          console.log("Server closed");
          resolve();
        })
      );
    } else {
      throw new Error("Server is not running");
    }
  }

  bind<BodyType, ResType, LocalsType>(options: {
    method: HttpMethod;
    route: string;
    validator: Validator<BodyType>;
    middleware: Middleware<BodyType, ResType, any>[];
    controller: Controller<BodyType, ResType, LocalsType>;
  }) {
    const validationMiddleware = (
      req: express.Request,
      res: express.Response,
      next: express.NextFunction
    ) => {
      try {
        options.validator({
          ...req.body,
          ...req.query,
          ...req.params,
        });
        next();
      } catch (err) {
        next(err);
      }
    };
    const errorHandler = (
      err: any,
      req: express.Request,
      res: express.Response,
      next: express.NextFunction
    ) => {
      return res.status(500).json(err);
    };
    const expressController = async (
      expressRequest: express.Request,
      expressResponse: express.Response
    ) => {
      try {
        return options.controller(
          new ExpressRequest(expressRequest),
          new ExpressResponse(expressResponse)
        );
      } catch (err) {
        return expressResponse.status(500).send(err);
      }
    };
    const expressMiddlewares = options.middleware.map(
      (m) =>
        async (
          expressRequest: express.Request,
          expressResponse: express.Response,
          next: express.NextFunction
        ) => {
          try {
            m(
              new ExpressRequest(expressRequest),
              new ExpressResponse(expressResponse),
              next
            );
          } catch (err) {
            next(err);
          }
        }
    );
    const stack = [
      validationMiddleware,
      ...expressMiddlewares,
      errorHandler,
      expressController,
    ];
    switch (options.method) {
      case HttpMethod.GET:
        this.expressApp.get(options.route, stack);
        break;
      case HttpMethod.POST:
        this.expressApp.post(options.route, stack);
        break;
      case HttpMethod.PUT:
        this.expressApp.put(options.route, stack);
        break;
      case HttpMethod.DELETE:
        this.expressApp.delete(options.route, stack);
        break;
      case HttpMethod.PATCH:
        this.expressApp.patch(options.route, stack);
        break;
    }
  }
}
