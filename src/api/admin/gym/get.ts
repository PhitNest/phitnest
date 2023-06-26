import { APIGatewayProxyResult } from "aws-lambda";
import { dynamo, handleRequest, Success } from "api/common/utils";
import { kGymWithoutAdminDynamo } from "api/common/entities";

export async function invoke(): Promise<APIGatewayProxyResult> {
  return await handleRequest(async () => {
    const client = dynamo().connect();
    const gyms = await client.parsedQuery({
      pk: "GYMS",
      sk: { q: "GYM#", op: "BEGINS_WITH" },
      parseShape: kGymWithoutAdminDynamo,
    });
    return new Success(gyms);
  });
}
