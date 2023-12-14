import { APIGatewayProxyResult } from "aws-lambda";
import { ZodError, z } from "zod";

/**
 * Return this to reply with a status code 200.
 */
export type Success = {
  responseType: "Success";
  body?: Record<string, unknown> | Record<string, unknown>[];
  headers?: { [header: string]: string };
};

/**
 * Return this to reply with a status code 500.
 */
export type RequestError<T extends string> = {
  responseType: "RequestError";
  type: T;
  message: string;
};

export type Response = Success | RequestError<string>;

export const kDefaultHeaders = {
  "Content-Type": "application/json",
  "Access-Control-Allow-Headers": "*",
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Methods": "OPTIONS,POST,GET,PUT,DELETE",
  "Access-Control-Allow-Credentials": "true",
};

/**
 * Use this to simplify the logic for request handling.
 *
 * @param controller This should return either a Success or RequestError.
 * @returns An APIGatewayProxyResult derived from either the Success the RequestError you return.
 */
export async function handleRequest(
  controller: () => Promise<Response>
): Promise<APIGatewayProxyResult> {
  try {
    const controllerOutput = await controller();
    if (controllerOutput.responseType === "RequestError") {
      return {
        statusCode: 500,
        headers: kDefaultHeaders,
        body: JSON.stringify({
          type: controllerOutput.type,
          message: controllerOutput.message,
        }),
      };
    } else if (controllerOutput.responseType === "Success") {
      return {
        statusCode: 200,
        body: controllerOutput.body
          ? JSON.stringify(controllerOutput.body)
          : "{}",
        headers: {
          ...kDefaultHeaders,
          ...(controllerOutput.headers ? controllerOutput.headers : {}),
        },
      };
    } else {
      return {
        statusCode: 500,
        headers: kDefaultHeaders,
        body: JSON.stringify({
          type: "InternalServerError",
          message:
            "The API did not return a Success or RequestError. Please look into the controller function you passed to handleRequest().",
        }),
      };
    }
  } catch (err: any) {
    if (err.responseType === "RequestError") {
      return {
        statusCode: 500,
        headers: kDefaultHeaders,
        body: JSON.stringify({
          type: err.type,
          message: err.message,
        }),
      };
    } else {
      return {
        statusCode: 500,
        headers: kDefaultHeaders,
        body: JSON.stringify(err),
      };
    }
  }
}

export function success(
  body?: Record<string, unknown> | Record<string, unknown>[],
  headers?: { [header: string]: string }
): Success {
  return {
    responseType: "Success",
    body: body,
    headers: headers,
  };
}

export function requestError<T extends string>(
  type: T,
  message: string
): RequestError<T> {
  return {
    responseType: "RequestError",
    type: type,
    message: message,
  };
}

interface ValidateRequestProps<
  ValidatorType extends z.ZodObject<z.ZodRawShape>,
> {
  /**
   * The data you want to validate.
   */
  data: object;

  /**
   * The Zod validator you want to use to validate the data.
   */
  validator: ValidatorType;

  /**
   * The controller function you want to use to handle the request.
   *
   * @param requestData The data that has been validated by the validator.
   * @returns Either a Success or RequestError.
   */
  controller: (
    requestData: z.infer<ValidatorType>
  ) => Promise<Success | RequestError<string>>;
}

export const kZodErrorType = "ValidationError";

/**
 * Use this to validate the request body with Zod and also handle the request.
 *
 * @param props Some settings to configure the request handling.
 * @returns An APIGatewayProxyResult derived from either the Success the RequestError you return.
 */
export async function validateRequest<
  ValidatorType extends z.ZodObject<z.ZodRawShape>,
>(props: ValidateRequestProps<ValidatorType>): Promise<APIGatewayProxyResult> {
  return await handleRequest(async () => {
    let data;
    try {
      data = props.validator.parse(props.data);
    } catch (err) {
      if (err instanceof ZodError) {
        return requestError(
          kZodErrorType,
          err.issues
            .map((issue) => issue.path.join(".") + ": " + issue.message)
            .join(", ")
        );
      }
      throw err;
    }
    return await props.controller(data);
  });
}
