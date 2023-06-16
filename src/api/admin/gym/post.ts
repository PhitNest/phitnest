import { APIGatewayEvent, APIGatewayProxyResult } from "aws-lambda";
// import { z } from "zod";
// import {
//   validateRequest,
//   getLocation,
//   dynamo,
//   RequestError,
//   kInvalidParameter,
//   Success,
//   getAdminClaims,
// } from "api/common/utils";
// import { gymToDynamo } from "api/common/entities";
// import * as uuid from "uuid";

// const validator = z.object({
//   name: z.string(),
//   adminEmail: z.string(),
//   street: z.string(),
//   city: z.string(),
//   state: z.string(),
//   zipCode: z.string(),
// });

export async function invoke(
  event: APIGatewayEvent
): Promise<APIGatewayProxyResult> {
  return {
    statusCode: 200,
    body: JSON.stringify(event.requestContext),
  };
  // return validateRequest({
  //   data: {
  //     ...JSON.parse(event.body ?? "{}"),
  //     adminEmail: getAdminClaims(event)?.email,
  //   },
  //   validator: validator,
  //   controller: async (data) => {
  //     const location = await getLocation(data);
  //     if (location) {
  //       const client = dynamo().connect();
  //       const gymId = uuid.v4();
  //       await client.put({
  //         pk: "GYMS",
  //         sk: `GYM#${gymId}`,
  //         data: gymToDynamo({
  //           id: gymId,
  //           createdAt: new Date(),
  //           adminEmail: data.adminEmail,
  //           name: data.name,
  //           address: {
  //             street: data.street,
  //             city: data.city,
  //             state: data.state,
  //             zipCode: data.zipCode,
  //           },
  //           location: location,
  //         }),
  //       });
  //       return new Success({
  //         gymId: gymId,
  //         location: location,
  //       });
  //     } else {
  //       return new RequestError(
  //         kInvalidParameter,
  //         "Could not locate the provided address."
  //       );
  //     }
  //   },
  // });
}
