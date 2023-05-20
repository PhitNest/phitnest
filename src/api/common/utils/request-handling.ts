import { APIGatewayProxyResult } from "aws-lambda";
import { ZodError, z } from "zod";

type SuccessResponse = {
  statusCode: 200;
  headers?: { [header: string]: string } & {
    "Content-Type"?: "text/plain" | "application/json";
  };
  body?: string;
};

type ErrorResponse = {
  statusCode: 400 | 500;
  headers?: { [header: string]: string } & {
    "Content-Type": "application/json";
  };
  body: { message: string };
};

export async function handleRequest(
  controller: () => Promise<SuccessResponse | ErrorResponse>
): Promise<APIGatewayProxyResult> {
  try {
    const controllerOutput = await controller();
    if (controllerOutput.statusCode === 200) {
      return {
        statusCode: controllerOutput.statusCode,
        body: controllerOutput.body ?? "",
        ...(controllerOutput.headers || controllerOutput.body
          ? {
              headers: controllerOutput.headers ?? {
                "Content-Type": "application/json",
              },
            }
          : {}),
      };
    } else {
      return {
        ...controllerOutput,
        body: JSON.stringify(controllerOutput.body),
      };
    }
  } catch (err) {
    return {
      statusCode: 500,
      headers: {
        "Content-Type": "application/json",
      },
      body: JSON.stringify(err),
    };
  }
}

export async function validateRequest<
  ValidatorType extends z.ZodObject<z.ZodRawShape>
>(props: {
  data: object;
  validator: ValidatorType;
  controller: (
    requestData: z.infer<ValidatorType>
  ) => Promise<SuccessResponse | ErrorResponse>;
}): Promise<APIGatewayProxyResult> {
  return await handleRequest(async () => {
    try {
      return await props.controller(props.validator.parse(props.data));
    } catch (err) {
      if (err instanceof ZodError) {
        return {
          statusCode: 400,
          headers: {
            "Content-Type": "application/json",
          },
          body: {
            message: err.issues
              .map((issue) => issue.path.join(".") + ": " + issue.message)
              .join(", "),
          },
        };
      }
      throw err;
    }
  });
}
