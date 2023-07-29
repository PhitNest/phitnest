import { APIGatewayProxyResult } from "aws-lambda";
import { kGymWithoutAdminParser } from "common/entities";
import {
  RequestError,
  ResourceNotFoundError,
  Success,
  dynamo,
  handleRequest,
} from "common/utils";

const kCouldNotFindGyms = new RequestError(
  "GymsNotFound",
  "Could not find gyms"
);

export async function invoke(): Promise<APIGatewayProxyResult> {
  return await handleRequest(async () => {
    const client = dynamo().connect();
    const gyms = await client.parsedQuery({
      pk: "GYMS",
      sk: { q: "GYM#", op: "BEGINS_WITH" },
      parseShape: kGymWithoutAdminParser,
    });
    if (gyms instanceof ResourceNotFoundError) {
      return kCouldNotFindGyms;
    } else {
      return new Success(gyms);
    }
  });
}
