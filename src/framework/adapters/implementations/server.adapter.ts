import express from "express";
import http from "http";
import { Failure, IRequest, IResponse } from "../../../common/types";
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
    this.expressApp.post("/", (req, res) => res.status(200).send());
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

  bind(controller: Controller<any>) {
    const validationMiddleware = (
      req: express.Request,
      res: express.Response,
      next: express.NextFunction
    ) => {
      try {
        if (controller.validator) {
          controller.validator.parse({
            ...req.body,
            ...req.query,
            ...req.params,
          });
        }
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
        const result = await controller.execute(
          new ExpressRequest(expressRequest),
          new ExpressResponse(expressResponse)
        );
        if (result instanceof Failure) {
          return expressResponse.status(500).json(result);
        } else if (result) {
          return expressResponse.status(200).json(result);
        } else {
          return expressResponse.status(200).send();
        }
      } catch (err) {
        return expressResponse.status(500).send(err);
      }
    };
    const expressMiddlewares = controller.middleware?.map(
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
    switch (controller.method) {
      case HttpMethod.GET:
        this.expressApp.get(controller.route, stack);
        break;
      case HttpMethod.POST:
        this.expressApp.post(controller.route, stack);
        break;
      case HttpMethod.PUT:
        this.expressApp.put(controller.route, stack);
        break;
      case HttpMethod.DELETE:
        this.expressApp.delete(controller.route, stack);
        break;
      case HttpMethod.PATCH:
        this.expressApp.patch(controller.route, stack);
        break;
    }
  }
}
