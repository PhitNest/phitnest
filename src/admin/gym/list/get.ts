import { APIGatewayProxyResult } from "aws-lambda";
import { Success, dynamo, handleRequest } from "common/utils";
import { getGyms } from "common/repository";

export async function invoke(): Promise<APIGatewayProxyResult> {
  return await handleRequest(async () => {
    const client = dynamo();
    return new Success(await getGyms(client));
  });
}
