import { APIGatewayProxyResult } from "aws-lambda";
import { connectDynamo } from "api/common/dynamo";
import * as uuid from "uuid";

export async function invoke(): Promise<APIGatewayProxyResult> {
  //event: APIGatewayEvent
  try {
    const client = connectDynamo();
    const gymId = uuid.v4();
    return {
      statusCode: 200,
      body: JSON.stringify({
        gymId: gymId,
        client: client,
      }),
    };
  } catch (err) {
    return {
      statusCode: 500,
      body: JSON.stringify(err),
    };
  }
}
