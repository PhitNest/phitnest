import { AttributeValue } from "@aws-sdk/client-dynamodb";
import {
  User,
  UserWithoutInvite,
  parseDynamo,
  userExploreToDynamo,
  userInvitedByAdminToDynamo,
  userInvitedByUserToDynamo,
  InviteTypeOnly,
  Invite,
  kInviteDynamo,
  kAdminInviteDynamo,
  kInviteTypeOnlyDynamo,
  AdminEmail,
  friendshipWithoutMessageToDynamo,
  FriendshipWithoutMessage,
} from "api/common/entities";
import { TransactionParams, dynamo } from "api/common/utils";
import { PreSignUpTriggerEvent } from "aws-lambda";
import * as uuid from "uuid";

const kInitialNumInvites = 5;

export async function invoke(event: PreSignUpTriggerEvent) {
  const client = dynamo().connect();

  // Required attributes given on signup
  const { firstName, lastName, inviterEmail } =
    event.request.validationData ?? {};
  if (!(firstName && lastName && inviterEmail)) {
    throw new Error("Missing required attributes");
  }

  // Check whether an invite from [inviterEmail] to [email] exists
  let inviteQuery: Record<string, AttributeValue>;
  try {
    inviteQuery = await client.query({
      pk: `INVITE#${inviterEmail}`,
      sk: { q: `RECEIVER#${event.request.userAttributes.email}`, op: "EQ" },
    });
  } catch {
    throw new Error(`You have not received an invite from: ${inviterEmail}`);
  }

  // Check whether the invite is from an admin or a user
  const invite = parseDynamo<InviteTypeOnly>(
    inviteQuery,
    kInviteTypeOnlyDynamo
  );
  const invitedByUser = invite.type === "user";

  // Transaction for writing to database (we are writing multiple objects)
  const transaction: TransactionParams<UserWithoutInvite, ":newNumInvites"> = {
    updates: [],
    puts: [],
    deletes: [],
  };

  const newUserExploreDetails = {
    accountDetails: {
      id: event.userName,
      email: event.request.userAttributes.email,
      createdAt: new Date(),
    },
    firstName: firstName,
    lastName: lastName,
  };

  // Parse as admin or user depending on the type
  let parsedInvite: Invite<UserWithoutInvite | AdminEmail>;
  if (invitedByUser) {
    const parsedInviteFromUser = parseDynamo<Invite<UserWithoutInvite>>(
      inviteQuery,
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

    const friendship: FriendshipWithoutMessage = {
      id: uuid.v4(),
      createdAt: new Date(),
      userTuple: [newUserExploreDetails, inviter],
    };

    transaction.puts.push({
      pk: `USER#${event.userName}`,
      sk: `FRIENDSHIP${inviter.accountDetails.id}`,
      data: friendshipWithoutMessageToDynamo(friendship),
    });
    transaction.puts.push({
      pk: `USER#${inviter.accountDetails.id}`,
      sk: `FRIENDSHIP${event.userName}`,
      data: friendshipWithoutMessageToDynamo(friendship),
    });
  } else {
    // If the inviter is an admin, no action needed after parsing
    parsedInvite = parseDynamo<Invite<AdminEmail>>(
      inviteQuery,
      kAdminInviteDynamo
    );
  }

  // Create our newly registered user
  const newUser: User = {
    ...newUserExploreDetails,
    numInvites: kInitialNumInvites,
    invite: parsedInvite,
  };

  transaction.puts.push(
    {
      // Add the users details to the DB
      pk: "USERS",
      sk: `USER#${event.userName}`,
      data: invitedByUser
        ? userInvitedByUserToDynamo(newUser as User<UserWithoutInvite>)
        : userInvitedByAdminToDynamo(newUser as User<AdminEmail>),
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
