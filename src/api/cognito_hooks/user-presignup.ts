import {
  User,
  Inviter,
  parseDynamo,
  userExploreToDynamo,
  userInvitedByAdminToDynamo,
  userInvitedByUserToDynamo,
  InviteTypeOnly,
  Admin,
  Invite,
  kInviteDynamo,
  kAdminInviteDynamo,
  kInviteTypeOnlyDynamo,
} from "api/common/entities";
import { TransactionParams, dynamo } from "api/common/utils";
import { PreSignUpTriggerEvent } from "aws-lambda";

const kInitialNumInvites = 5;

export async function invoke(event: PreSignUpTriggerEvent) {
  const client = dynamo().connect();

  // Required attributes given on signup
  const { email, firstName, lastName, inviterEmail } =
    event.request.userAttributes;
  if (!(email && firstName && lastName && inviterEmail)) {
    throw new Error("Missing required attributes");
  }

  // Check whether an invite from [inviterEmail] to [email] exists
  const inviteQuery = await client.query({
    pk: `INVITE#${inviterEmail}`,
    sk: { q: `RECEIVER#${email}`, op: "EQ" },
  });
  if (inviteQuery.length !== 1) {
    throw new Error(`You have not received an invite from: ${inviterEmail}`);
  }

  // Check whether the invite is from an admin or a user
  const invite = parseDynamo<InviteTypeOnly>(
    inviteQuery[0],
    kInviteTypeOnlyDynamo
  );
  const invitedByUser = invite.type === "user";

  // Transaction for writing to database (we are writing multiple objects)
  const transaction: TransactionParams<Inviter, ":newNumInvites"> = {
    updates: [],
    puts: [],
  };

  // Parse as admin or user depending on the type
  let parsedInvite: Invite<Inviter | Admin>;
  if (invitedByUser) {
    const parsedInviteFromUser = parseDynamo<Invite<Inviter>>(
      inviteQuery[0],
      kInviteDynamo
    );
    parsedInvite = parsedInviteFromUser;
    const inviter = parsedInviteFromUser.inviter;

    // Check that inviter has invite remaining
    if (inviter.numInvites <= 0) {
      throw new Error(`${inviter.accountDetails.email} has no invites left`);
    }

    // Decrement the inviters remaining invites
    transaction.updates.push({
      pk: "USERS",
      sk: `USER#${inviter.accountDetails.id}`,
      expression: "SET numInvites = numInvites",
      varMap: {
        ":newNumInvites": {
          N: `${inviter.numInvites - 1}`,
        },
      },
    });
  } else {
    // If the inviter is an admin, no action needed after parsing
    parsedInvite = parseDynamo<Invite<Admin>>(
      inviteQuery[0],
      kAdminInviteDynamo
    );
  }

  // Create our newly registered user
  const newUser: User = {
    accountDetails: {
      id: event.userName,
      email: email,
      createdAt: new Date(),
    },
    firstName: firstName,
    lastName: lastName,
    numInvites: kInitialNumInvites,
    invite: parsedInvite,
  };

  transaction.puts.push(
    {
      // Add the users details to the DB
      pk: "USERS",
      sk: `USER#${event.userName}`,
      data: invitedByUser
        ? userInvitedByUserToDynamo(newUser as User<Inviter>)
        : userInvitedByAdminToDynamo(newUser as User<Admin>),
    },
    {
      // Add the required user details to the gym PK so users can be explored/queried by gym
      pk: `GYM#${parsedInvite.gym.id}`,
      sk: `USER#${event.userName}`,
      data: userExploreToDynamo(newUser),
    }
  );

  await client.writeTransaction(transaction);
  return event;
}
