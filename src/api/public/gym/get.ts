import { APIGatewayProxyResult } from "aws-lambda";
import { connectDynamo, handleRequest } from "api/common/utils";
import { QueryCommand } from "@aws-sdk/client-dynamodb";

export async function invoke(): Promise<APIGatewayProxyResult> {
  return await handleRequest(async () => {
    const client = connectDynamo();
    return {
      statusCode: 200,
      body: JSON.stringify(
        (
          await client.send(
            new QueryCommand({
              TableName: process.env.DYNAMO_TABLE_NAME,
              KeyConditions: {
                part_id: {
                  ComparisonOperator: "EQ",
                  AttributeValueList: [{ S: "GYMS" }],
                },
                sort_id: {
                  ComparisonOperator: "BEGINS_WITH",
                  AttributeValueList: [{ S: "GYM#" }],
                },
              },
            })
          )
        ).Items
      ),
    };
  });
}
