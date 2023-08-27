import { APIGatewayProxyResult } from "aws-lambda";
import { kGymParser } from "common/entities";
import { Success, dynamo, handleRequest } from "common/utils";

export async function invoke(): Promise<APIGatewayProxyResult> {
  return await handleRequest(async () => {
    const client = dynamo();
    const gyms = await client.parsedQuery({
      pk: "GYMS",
      sk: { q: "GYM#", op: "BEGINS_WITH" },
      parseShape: kGymParser,
    });
    return new Success(gyms);
  });
}
