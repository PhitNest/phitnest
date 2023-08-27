import { kInviteParser, userWithoutIdentityToDynamo } from "common/entities";
import { PreSignUpTriggerEvent } from "aws-lambda";
import { ResourceNotFoundError, dynamo } from "common/utils";

const kInitialNumInvites = 5;

export async function invoke(event: PreSignUpTriggerEvent) {
  const client = dynamo();
  const { firstName, lastName } = event.request.validationData ?? {};
  if (!firstName) {
    throw new Error("Missing firstName");
  }
  if (!lastName) {
    throw new Error("Missing lastName");
  }
  const newUserWithoutInvite = {
    id: event.userName,
    email: event.request.userAttributes.email,
    createdAt: new Date(),
    firstName: firstName,
    lastName: lastName,
    numInvites: kInitialNumInvites,
  };
  let invite = await client.parsedQuery({
    pk: `INVITE#${event.request.userAttributes.email}`,
    sk: { q: "ADMIN#", op: "BEGINS_WITH" },
    table: "inverted",
    limit: 1,
    parseShape: kInviteParser,
  });
  if (invite instanceof ResourceNotFoundError) {
    invite = await client.parsedQuery({
      pk: `INVITE#${event.request.userAttributes.email}`,
      sk: { q: "USER#", op: "BEGINS_WITH" },
      table: "inverted",
      limit: 1,
      parseShape: kInviteParser,
    });
    if (invite instanceof ResourceNotFoundError) {
      throw new Error(JSON.stringify(invite));
    }
  }
  await client.put({
    pk: `USER#${event.userName}`,
    sk: `NEW#${event.userName}`,
    data: userWithoutIdentityToDynamo({
      ...newUserWithoutInvite,
      invite: invite,
    }),
  });
  return event;
}
