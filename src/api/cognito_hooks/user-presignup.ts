import {
  QueryCommand,
  TransactWriteItem,
  TransactWriteItemsCommand,
} from "@aws-sdk/client-dynamodb";
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
import { connectDynamo } from "api/common/utils";
import { PreSignUpTriggerEvent } from "aws-lambda";

const kInitialNumInvites = 5;

export async function invoke(event: PreSignUpTriggerEvent) {
  const client = connectDynamo();

  // Required attributes given on signup
  const { email, firstName, lastName, inviterEmail } =
    event.request.userAttributes;
  if (!(email && firstName && lastName && inviterEmail)) {
    throw new Error("Missing required attributes");
  }

  // Check whether an invite from [inviterEmail] to [email] exists
  const inviteQuery = await client.send(
    new QueryCommand({
      TableName: process.env.DYNAMO_TABLE_NAME,
      KeyConditions: {
        part_id: {
          ComparisonOperator: "EQ",
          AttributeValueList: [{ S: `INVITE#${inviterEmail}` }],
        },
        sort_id: {
          ComparisonOperator: "EQ",
          AttributeValueList: [{ S: `RECEIVER#${email}` }],
        },
      },
    })
  );
  if (!(inviteQuery.Items && inviteQuery.Items.length === 1)) {
    throw new Error(`You have not received an invite from: ${inviterEmail}`);
  }

  // Transaction for writing to database (we are writing multiple objects)
  const transaction: TransactWriteItem[] = [];

  // Check whether the invite is from an admin or a user
  const invite = parseDynamo<InviteTypeOnly>(
    inviteQuery.Items[0],
    kInviteTypeOnlyDynamo
  );
  const invitedByUser = invite.type === "user";

  // Parse as admin or user depending on the type
  let parsedInvite: Invite<Inviter | Admin>;
  if (invitedByUser) {
    const parsedInviteFromUser = parseDynamo<Invite<Inviter>>(
      inviteQuery.Items[0],
      kInviteDynamo
    );
    parsedInvite = parsedInviteFromUser;
    const inviter = parsedInviteFromUser.inviter;

    // Check that inviter has invite remaining
    if (inviter.numInvites <= 0) {
      throw new Error(`${inviter.accountDetails.email} has no invites left`);
    }

    // Decrement the inviters remaining invites
    transaction.push({
      Update: {
        TableName: process.env.DYNAMO_TABLE_NAME,
        Key: {
          part_id: { S: "USERS" },
          sort_id: {
            S: `USER#${inviter.accountDetails.id}`,
          },
        },
        UpdateExpression: "SET numInvites = numInvites - 1",
      },
    });
  } else {
    // If the inviter is an admin, no action needed after parsing
    parsedInvite = parseDynamo<Invite<Admin>>(
      inviteQuery.Items[0],
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

  transaction.push(
    {
      // Add the users details to the DB
      Put: {
        TableName: process.env.DYNAMO_TABLE_NAME,
        Item: {
          part_id: { S: "USERS" },
          sort_id: { S: `USER#${event.userName}` },
          ...(invitedByUser
            ? userInvitedByUserToDynamo(newUser as User<Inviter>)
            : userInvitedByAdminToDynamo(newUser as User<Admin>)),
        },
      },
    },
    {
      // Add the required user details to the gym PK so users can be explored/queried by gym
      Put: {
        TableName: process.env.DYNAMO_TABLE_NAME,
        Item: {
          part_id: { S: `GYM#${parsedInvite.gym.id}` },
          sort_id: { S: `USER#${event.userName}` },
          ...userExploreToDynamo(newUser),
        },
      },
    }
  );

  await client.send(
    new TransactWriteItemsCommand({
      TransactItems: transaction,
    })
  );
  return event;
}
