import { z } from "zod";
import { Failure } from "./failures";
import {
  APIGatewayProxyEventPathParameters,
  APIGatewayProxyEventQueryStringParameters,
} from "aws-lambda";

export function errorResponse(error: any): {
  statusCode: number;
  body: string;
} {
  return {
    statusCode: 500,
    body: JSON.stringify(error),
  };
}

export function successResponse(body: any): {
  statusCode: number;
  body: string;
} {
  return {
    statusCode: 200,
    body: JSON.stringify(body),
  };
}

export async function respond<
  InputSchema extends z.ZodSchema,
  BodyType extends
    | APIGatewayProxyEventPathParameters
    | APIGatewayProxyEventQueryStringParameters
    | string
    | null
    | undefined
>(params: {
  controller: (body: z.output<InputSchema>) => Promise<any>;
  body?: BodyType;
  validator?: InputSchema;
}): Promise<{
  statusCode: number;
  body: any;
}> {
  try {
    let parsedBody: z.output<InputSchema> | undefined;
    if (params.validator) {
      if (typeof params.body === "string") {
        parsedBody = params.validator.parse(
          params.body.length === 0 ? {} : JSON.parse(params.body)
        );
      } else if (params.body === null || params.body === undefined) {
        parsedBody = params.validator.parse({});
      } else {
        parsedBody = params.validator.parse(
          Object.fromEntries(
            Object.entries(params.body).map(([key, value]) => {
              if (value) {
                if (value === "true") {
                  return [key, true];
                } else if (value === "false") {
                  return [key, false];
                }
                const parsedNum = parseFloat(value);
                if (!isNaN(parsedNum)) {
                  return [key, parsedNum];
                }
              }
              return [key, value];
            })
          )
        );
      }
    }
    const response = await params.controller(parsedBody);
    if (response instanceof Failure) {
      return errorResponse(response);
    } else {
      return successResponse(response);
    }
  } catch (error: any) {
    return errorResponse(error);
  }
}
