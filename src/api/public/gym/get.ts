import { APIGatewayProxyResult } from "aws-lambda";
import { dynamo, handleRequest } from "api/common/utils";
import { kGymDynamo } from "api/common/entities";

export async function invoke(): Promise<APIGatewayProxyResult> {
  return await handleRequest(async () => {
    const client = dynamo().connect();
    return {
      statusCode: 200,
      body: JSON.stringify(
        await client.parsedQuery({
          pk: "GYMS",
          sk: { q: "GYM#", op: "BEGINS_WITH" },
          parseShape: kGymDynamo,
        })
      ),
    };
  });
}
