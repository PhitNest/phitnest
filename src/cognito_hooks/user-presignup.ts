import {
  parseDynamo,
  InviteWithoutSender,
  kInviteWithoutSenderParser,
  UserInvite,
  AdminInvite,
  kUserInviteParser,
  kAdminInviteParser,
  UserWithoutInviteOrIdentity,
  userInvitedByAdminWithoutIdentityToDynamo,
  userInvitedByUserWithoutIdentityToDynamo,
} from "common/entities";
import { ResourceNotFoundError, dynamo } from "common/utils";
import { PreSignUpTriggerEvent } from "aws-lambda";

const kInitialNumInvites = 5;

export async function invoke(event: PreSignUpTriggerEvent) {
  const client = dynamo();

  // Required attributes given on signup
  const { firstName, lastName, inviterEmail } =
    event.request.validationData ?? {};
  if (!firstName) {
    throw new Error("Missing firstName");
  }
  if (!lastName) {
    throw new Error("Missing lastName");
  }
  if (!inviterEmail) {
    throw new Error("Missing inviterEmail");
  }

  // Check whether an invite from inviterEmail to email exists
  const inviteRaw = await client.query({
    pk: `INVITE#${inviterEmail}`,
    sk: { q: `RECEIVER#${event.request.userAttributes.email}`, op: "EQ" },
  });
  if (inviteRaw instanceof ResourceNotFoundError) {
    throw new Error(`You have not received an invite from: ${inviterEmail}`);
  }

  // Check whether the invite is from an admin or a user
  const invite = parseDynamo<InviteWithoutSender>(
    inviteRaw,
    kInviteWithoutSenderParser
  );
  const invitedByUser = invite.type === "user";

  const newUserWithoutInvite: UserWithoutInviteOrIdentity = {
    id: event.userName,
    email: event.request.userAttributes.email,
    createdAt: new Date(),
    firstName: firstName,
    lastName: lastName,
    numInvites: kInitialNumInvites,
  };

  // Parse as admin or user depending on the type
  if (invitedByUser) {
    const parsedInviteFromUser = parseDynamo<UserInvite>(
      inviteRaw,
      kUserInviteParser
    );
    const inviter = parsedInviteFromUser.inviter;

    // Check that inviter has invite remaining
    if (inviter.numInvites <= 0) {
      throw new Error(`${inviter.email} has no invites left`);
    }

    await client.writeTransaction({
      updates: [
        {
          pk: "USERS",
          sk: `USER#${inviter.id}`,
          expression: "SET numInvites = numInvites - 1",
          varMap: {},
        },
      ],
      puts: [
        {
          pk: "USERS",
          sk: `USER#${event.userName}`,
          data: userInvitedByUserWithoutIdentityToDynamo({
            ...newUserWithoutInvite,
            invite: parsedInviteFromUser,
          }),
        },
      ],
    });
  } else {
    // If the inviter is an admin, no action needed after parsing
    const parsedInviteFromAdmin = parseDynamo<AdminInvite>(
      inviteRaw,
      kAdminInviteParser
    );

    await client.put({
      pk: "USERS",
      sk: `USER#${event.userName}`,
      data: userInvitedByAdminWithoutIdentityToDynamo({
        ...newUserWithoutInvite,
        invite: parsedInviteFromAdmin,
      }),
    });
  }
  return event;
}
