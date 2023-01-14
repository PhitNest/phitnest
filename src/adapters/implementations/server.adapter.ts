import express from "express";
import http from "http";
import { Failure, IRequest, IResponse } from "../../common/types";
import { Controller, HttpMethod } from "../../controllers/types";
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
    return new Promise<http.Server>((resolve) =>
      this.server!.listen(port, () => {
        console.log(`Server listening on port ${port}`);
        resolve(this.server!);
      })
    );
  }

  bind<BodyType, ResType, LocalsType>(options: {
    route: string;
    controller: Controller<BodyType, ResType, LocalsType>;
  }) {
    const validationMiddleware = (
      req: express.Request,
      res: express.Response,
      next: express.NextFunction
    ) => {
      try {
        options.controller.validate({
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
        const result = await options.controller.execute(
          new ExpressRequest(expressRequest),
          new ExpressResponse(expressResponse)
        );
        if (result instanceof Failure) {
          return expressResponse.status(500).json(result);
        } else {
          return expressResponse.status(200).json(result);
        }
      } catch (err) {
        return expressResponse.status(500).send(err);
      }
    };
    const expressMiddlewares = options.controller.middleware?.map(
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
      ...(expressMiddlewares ?? []),
      errorHandler,
      expressController,
    ];
    switch (options.controller.method) {
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
