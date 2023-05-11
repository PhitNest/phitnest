import { APIGatewayEvent, APIGatewayProxyResult } from "aws-lambda";
import { PutItemCommand } from "@aws-sdk/client-dynamodb";
import { connectDynamo } from "api/common/dynamo";
import { z } from "zod";
import * as uuid from "uuid";

export async function invoke(
  event: APIGatewayEvent
): Promise<APIGatewayProxyResult> {
  try {
    const validator = z.object({
      name: z.string(),
      street: z.string(),
      city: z.string(),
      state: z.string(),
      zipCode: z.string(),
    });
    const body = validator.parse(JSON.parse(event.body || ""));
    const client = connectDynamo();
    const gymId = uuid.v4();
    await client.send(
      new PutItemCommand({
        TableName: process.env.DYNAMO_TABLE_NAME,
        Item: {
          part_id: { S: "GYMS" },
          sort_id: { S: `GYM#${gymId}` },
          name: { S: body.name },
          street: { S: body.street },
          city: { S: body.city },
          state: { S: body.state },
          zipCode: { S: body.zipCode },
        },
      })
    );
    return {
      statusCode: 200,
      body: gymId,
    };
  } catch (err) {
    return {
      statusCode: 500,
      body: JSON.stringify(err),
    };
  }
}
