import { APIGatewayProxyResult } from "aws-lambda";
import { kGymWithoutAdminParser } from "common/entities";
import { RequestError, Success, dynamo, handleRequest } from "common/utils";

export async function invoke(): Promise<APIGatewayProxyResult> {
  return await handleRequest(async () => {
    const client = dynamo().connect();
    const gyms = await client.parsedQuery({
      pk: "GYMS",
      sk: { q: "GYM#", op: "BEGINS_WITH" },
      parseShape: kGymWithoutAdminParser,
    });
    if (gyms instanceof RequestError) {
      return gyms;
    } else {
      return new Success(gyms);
    }
  });
}
