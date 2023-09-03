import { APIGatewayProxyResult } from "aws-lambda";
import { Success, dynamo, handleRequest } from "typescript-core/src/utils";
import { getGyms } from "typescript-core/src/repositories";

export async function invoke(): Promise<APIGatewayProxyResult> {
  return await handleRequest(async () => {
    const client = dynamo();
    return new Success(await getGyms(client));
  });
}
