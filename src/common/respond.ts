import { z } from "zod";
import { Failure } from "./failures";

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

export async function respond<InputSchema extends z.ZodSchema>(params: {
  controller: (body: z.output<InputSchema>) => Promise<any>;
  body?: any | null;
  validator?: InputSchema;
}): Promise<{
  statusCode: number;
  body: any;
}> {
  try {
    const response = await (params.validator
      ? params.controller(
          params.validator.parse(JSON.parse(params.body ?? "{}"))
        )
      : params.controller(undefined));
    if (response instanceof Failure) {
      return errorResponse(response);
    } else {
      return successResponse(response);
    }
  } catch (error: any) {
    return errorResponse(error);
  }
}
