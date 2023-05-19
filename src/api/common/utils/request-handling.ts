import { APIGatewayProxyResult } from "aws-lambda";
import { ZodError, z } from "zod";

export async function handleRequest(
  controller: () => Promise<{
    statusCode: number;
    headers?: { [header: string]: string } & {
      "Content-Type"?: "text/plain" | "application/json";
    };
    body?: string;
  }>
): Promise<APIGatewayProxyResult> {
  try {
    const controllerOutput = await controller();
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
  ValidatorType extends z.ZodObject<any>
>(props: {
  data: any;
  validator: ValidatorType;
  controller: (requestData: z.infer<ValidatorType>) => Promise<{
    statusCode: number;
    headers?: { [header: string]: string } & {
      "Content-Type"?: "text/plain" | "application/json";
    };
    body?: string;
  }>;
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
          body: JSON.stringify(err.issues),
        };
      }
      throw err;
    }
  });
}
