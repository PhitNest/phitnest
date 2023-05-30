import {
  QueryCommand,
  TransactWriteItem,
  TransactWriteItemsCommand,
} from "@aws-sdk/client-dynamodb";
import {
  InviteWithoutGym,
  InviteWithoutUser,
  User,
  kAdminInviteWithoutGymDynamo,
  kInviteWithoutGymDynamo,
  kInviteWithoutUserDynamo,
  parseDynamo,
  userExploreToDynamo,
  userInvitedByAdminToDynamo,
  userInvitedByUserToDynamo,
} from "api/common/entities";
import { connectDynamo } from "api/common/utils";
import { PreSignUpTriggerEvent } from "aws-lambda";

const kInitialNumInvites = 5;

export async function invoke(event: PreSignUpTriggerEvent) {
  const client = connectDynamo();
  const { email, firstName, lastName, inviterEmail } =
    event.request.userAttributes;
  if (email && firstName && lastName && inviterEmail) {
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
    if (inviteQuery.Items && inviteQuery.Items.length === 1) {
      const invite = parseDynamo<InviteWithoutUser>(
        inviteQuery.Items[0],
        kInviteWithoutUserDynamo
      );
      const invitedByUser = invite.type === "user";
      const parsedInvite = parseDynamo<InviteWithoutGym<typeof invite.type>>(
        inviteQuery.Items[0],
        invitedByUser ? kInviteWithoutGymDynamo : kAdminInviteWithoutGymDynamo
      );
      const newUser: User = {
        accountDetails: {
          id: event.userName,
          email: email,
          createdAt: new Date(),
        },
        gym: invite.gym,
        firstName: firstName,
        lastName: lastName,
        numInvites: kInitialNumInvites,
        invite: parsedInvite,
      };
      const transactions: TransactWriteItem[] = [
        {
          Put: {
            TableName: process.env.DYNAMO_TABLE_NAME,
            Item: {
              part_id: { S: "USERS" },
              sort_id: { S: `USER#${event.userName}` },
              ...(invitedByUser
                ? userInvitedByUserToDynamo(newUser as User<"user">)
                : userInvitedByAdminToDynamo(newUser as User<"admin">)),
            },
          },
        },
        {
          Put: {
            TableName: process.env.DYNAMO_TABLE_NAME,
            Item: {
              part_id: { S: `GYM#${invite.gym.id}` },
              sort_id: { S: `USER#${event.userName}` },
              ...userExploreToDynamo(newUser),
            },
          },
        },
      ];
      if (invitedByUser) {
        const inviter = (parsedInvite as InviteWithoutGym<"user">).inviter;
        if (inviter.numInvites <= 0) {
          throw new Error(
            `${inviter.accountDetails.email} has no invites left`
          );
        }
        transactions.push({
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
      }
      await client.send(
        new TransactWriteItemsCommand({
          TransactItems: transactions,
        })
      );
      return event;
    }
    throw new Error(`You have not received an invite from: ${inviterEmail}`);
  } else {
    throw new Error("Missing required attributes");
  }
}
