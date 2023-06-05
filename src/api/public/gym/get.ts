import { APIGatewayProxyResult } from "aws-lambda";
import { dynamo, handleRequest, Success } from "api/common/utils";
import { kGymWithoutAdminDynamo } from "api/common/entities";

export async function invoke(): Promise<APIGatewayProxyResult> {
  return await handleRequest(async () => {
    const client = dynamo().connect();
    return new Success(
      await client.parsedQuery({
        pk: "GYMS",
        sk: { q: "GYM#", op: "BEGINS_WITH" },
        parseShape: kGymWithoutAdminDynamo,
      })
    );
  });
}
