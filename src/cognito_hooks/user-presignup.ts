import {
  UserWithoutInvite,
  parseDynamo,
  InviteWithoutSender,
  kInviteWithoutSenderParser,
  UserInvite,
  AdminInvite,
  kUserInviteParser,
  kAdminInviteParser,
  UserInvitedByUser,
  UserInvitedByAdmin,
  UserInvitedByUserWithoutIdentity,
  UserInvitedByAdminWithoutIdentity,
  userInvitedByAdminWithoutIdentityToDynamo,
  userInvitedByUserWithoutIdentityToDynamo,
} from "common/entities";
import { ResourceNotFoundError, TransactionParams, dynamo } from "common/utils";
import { PreSignUpTriggerEvent } from "aws-lambda";

const kInitialNumInvites = 5;

export async function invoke(event: PreSignUpTriggerEvent) {
  const client = dynamo().connect();

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
  const inviteQuery = await client.query({
    pk: `INVITE#${inviterEmail}`,
    sk: { q: `RECEIVER#${event.request.userAttributes.email}`, op: "EQ" },
  });
  if (inviteQuery instanceof ResourceNotFoundError) {
    throw new Error(`You have not received an invite from: ${inviterEmail}`);
  }

  // Check whether the invite is from an admin or a user
  const invite = parseDynamo<InviteWithoutSender>(
    inviteQuery,
    kInviteWithoutSenderParser
  );

  const invitedByUser = invite.type === "user";

  // Transaction for writing to database (we are writing multiple objects)
  const transaction: TransactionParams<UserWithoutInvite> = {
    updates: [],
    puts: [],
    deletes: [],
  };

  const newUserWithoutInvite: Omit<UserWithoutInvite, "identityId"> = {
    id: event.userName,
    email: event.request.userAttributes.email,
    createdAt: new Date(),
    firstName: firstName,
    lastName: lastName,
    numInvites: kInitialNumInvites,
  };

  let newUser:
    | UserInvitedByUserWithoutIdentity
    | UserInvitedByAdminWithoutIdentity;
  // Parse as admin or user depending on the type
  if (invitedByUser) {
    const parsedInviteFromUser = parseDynamo<UserInvite>(
      inviteQuery,
      kUserInviteParser
    );
    const inviter = parsedInviteFromUser.inviter;

    // Check that inviter has invite remaining
    if (inviter.numInvites <= 0) {
      throw new Error(`${inviter.email} has no invites left`);
    }

    // Decrement the inviters remaining invites
    transaction.updates.push({
      pk: "USERS",
      sk: `USER#${inviter.id}`,
      expression: "SET numInvites = numInvites - 1",
    });

    // Create our newly registered user
    newUser = {
      ...newUserWithoutInvite,
      invite: parsedInviteFromUser,
    };
  } else {
    // If the inviter is an admin, no action needed after parsing
    const parsedInviteFromAdmin = parseDynamo<AdminInvite>(
      inviteQuery,
      kAdminInviteParser
    );
    // Create our newly registered user
    newUser = {
      ...newUserWithoutInvite,
      invite: parsedInviteFromAdmin,
    };
  }

  // Add the users details to the DB
  transaction.puts.push({
    pk: "USERS",
    sk: `USER#${event.userName}`,
    data: invitedByUser
      ? userInvitedByUserWithoutIdentityToDynamo(newUser as UserInvitedByUser)
      : userInvitedByAdminWithoutIdentityToDynamo(
          newUser as UserInvitedByAdmin
        ),
  });

  await client.writeTransaction(transaction);
  return event;
}
