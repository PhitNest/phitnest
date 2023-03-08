import { z } from "zod";
import { Failure } from "./failure";

function errorResponse(error: any): {
  statusCode: number;
  body: string;
} {
  return {
    statusCode: 500,
    body: JSON.stringify(error),
  };
}

function successResponse(body: any): {
  statusCode: number;
  body: string;
} {
  return {
    statusCode: 200,
    body: JSON.stringify(body),
  };
}

export async function respond<InputType>(params: {
  controller: (body: InputType) => Promise<any>;
  body?: string | null;
  validator?: z.ZodSchema<InputType>;
}): Promise<{
  statusCode: number;
  body: any;
}> {
  try {
    const response = await (params.validator != null
      ? params.controller(
          params.validator.parse(JSON.parse(params.body ?? "{}"))
        )
      : params.controller(undefined as InputType));
    if (response instanceof Failure) {
      return errorResponse(response);
    } else {
      return successResponse(response);
    }
  } catch (error: any) {
    return errorResponse(error);
  }
}
