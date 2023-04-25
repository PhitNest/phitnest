import { z } from "zod";
import { Failure } from "./failures";
import { APIGatewayEvent } from "aws-lambda";

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

export async function respond<InputSchema extends z.ZodSchema>(
  event: APIGatewayEvent,
  controller: (body: z.output<InputSchema>) => Promise<any>,
  validator?: InputSchema
): Promise<{
  statusCode: number;
  body: any;
}> {
  try {
    let parsedBody: z.output<InputSchema> | undefined;
    if (validator) {
      let input: any;
      switch (event.httpMethod) {
        case "GET":
        case "DELETE":
          input = { ...event.queryStringParameters, ...event.pathParameters };
          break;
        case "POST":
        case "PUT":
          input = JSON.parse(event.body || "{}");
          break;
        default:
          return errorResponse(
            new Failure("BadHTTP", "Unsupported HTTP method")
          );
      }
      parsedBody = validator.parse(input);
    }
    const response = await controller(parsedBody);
    if (response instanceof Failure) {
      return errorResponse(response);
    } else {
      return successResponse(response);
    }
  } catch (error: any) {
    return errorResponse(error);
  }
}
