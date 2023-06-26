import { APIGatewayProxyResult } from "aws-lambda";
import { ZodError, z } from "zod";
import { kZodError } from "./errors";

export class Success {
  body?: Record<string, unknown> | Record<string, unknown>[];
  headers?: { [header: string]: string };

  constructor(
    body?: Record<string, unknown> | Record<string, unknown>[],
    headers?: { [header: string]: string }
  ) {
    this.body = body;
    this.headers = headers;
  }
}

export class RequestError {
  type: string;
  message: string;

  constructor(type: string, message: string) {
    this.type = type;
    this.message = message;
  }
}

export async function handleRequest(
  controller: () => Promise<Success | RequestError>
): Promise<APIGatewayProxyResult> {
  try {
    const controllerOutput = await controller();
    if (controllerOutput instanceof RequestError) {
      return {
        statusCode: 500,
        headers: {
          "Content-Type": "application/json",
        },
        body: JSON.stringify({
          type: controllerOutput.type,
          message: controllerOutput.message,
        }),
      };
    } else {
      return {
        statusCode: 200,
        body: controllerOutput.body
          ? JSON.stringify(controllerOutput.body)
          : "",
        ...(controllerOutput.body
          ? {
              headers: {
                "Content-Type": "application/json",
              },
            }
          : {}),
        ...(controllerOutput.headers
          ? {
              headers: controllerOutput.headers,
            }
          : {}),
      };
    }
  } catch (err) {
    if (err instanceof RequestError) {
      return {
        statusCode: 500,
        headers: {
          "Content-Type": "application/json",
        },
        body: JSON.stringify({
          type: err.type,
          message: err.message,
        }),
      };
    } else {
      return {
        statusCode: 500,
        headers: {
          "Content-Type": "application/json",
        },
        body: JSON.stringify(err),
      };
    }
  }
}

export async function validateRequest<
  ValidatorType extends z.ZodObject<z.ZodRawShape>
>(props: {
  data: object;
  validator: ValidatorType;
  controller: (
    requestData: z.infer<ValidatorType>
  ) => Promise<Success | RequestError>;
}): Promise<APIGatewayProxyResult> {
  return await handleRequest(async () => {
    try {
      return await props.controller(props.validator.parse(props.data));
    } catch (err) {
      if (err instanceof ZodError) {
        return new RequestError(
          kZodError,
          err.issues
            .map((issue) => issue.path.join(".") + ": " + issue.message)
            .join(", ")
        );
      }
      throw err;
    }
  });
}
