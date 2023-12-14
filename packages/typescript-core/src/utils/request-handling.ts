import { APIGatewayProxyResult } from "aws-lambda";
import { ZodError, z } from "zod";

const kSuccess = "Success";
const kRequestError = "RequestError";

/**
 * Return this to reply with a status code 200.
 */
export type Success = {
  responseType: typeof kSuccess;
  body?: Record<string, unknown> | Record<string, unknown>[];
  headers?: { [header: string]: string };
};

/**
 * Return this to reply with a status code 500.
 */
export type RequestError<T extends string> = {
  responseType: typeof kRequestError;
  type: T;
  message: string;
};

/**
 * This is the type of the response you should return from your controller function.
 */
export type Response = Success | RequestError<string>;

/**
 * Use this to check if the response is a Success.
 */
export function isSuccess(response: Response): response is Success {
  return response.responseType === kSuccess;
}

/**
 * Use this to create a Success.
 */
export function success(
  body?: Record<string, unknown> | Record<string, unknown>[],
  headers?: { [header: string]: string }
): Success {
  return {
    responseType: kSuccess,
    body: body,
    headers: headers,
  };
}

/**
 * Use this to check if the response is a RequestError.
 */
export function isRequestError(
  response: any
): response is RequestError<string> {
  return response.responseType === kRequestError;
}

/**
 * Use this to create a RequestError.
 */
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

/**
 * Use this to check if the response is a RequestError of a specific type.
 */
export function isRequestErrorOfType<T extends string>(
  response: RequestError<string>,
  type: T
): response is RequestError<T> {
  return response.type === type;
}

/**
 * These are the default headers that will be added to every response.
 */
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
    if (isRequestError(controllerOutput)) {
      return {
        statusCode: 500,
        headers: kDefaultHeaders,
        body: JSON.stringify({
          type: controllerOutput.type,
          message: controllerOutput.message,
        }),
      };
    } else if (isSuccess(controllerOutput)) {
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
    if (isRequestError(err)) {
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
