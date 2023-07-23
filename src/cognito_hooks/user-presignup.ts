import {
  UserWithoutInvite,
  parseDynamo,
  userExploreToDynamo,
  userInvitedByAdminToDynamo,
  userInvitedByUserToDynamo,
  friendshipWithoutMessageToDynamo,
  FriendshipWithoutMessage,
  InviteWithoutSender,
  kInviteWithoutSenderParser,
  UserInvite,
  AdminInvite,
  kUserInviteParser,
  kAdminInviteParser,
  UserInvitedByUser,
  UserInvitedByAdmin,
} from "common/entities";
import {
  ResourceNotFoundError,
  TransactionParams,
  dynamo,
  DynamoParseError,
} from "common/utils";
import { PreSignUpTriggerEvent } from "aws-lambda";
import * as uuid from "uuid";

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
  if (invite instanceof DynamoParseError) {
    throw new Error(invite.message);
  } else {
    const invitedByUser = invite.type === "user";

    // Transaction for writing to database (we are writing multiple objects)
    const transaction: TransactionParams<UserWithoutInvite> = {
      updates: [],
      puts: [],
      deletes: [],
    };

    const newUserExplore = {
      id: event.userName,
      email: event.request.userAttributes.email,
      createdAt: new Date(),
      firstName: firstName,
      lastName: lastName,
    };

    let newUser: UserInvitedByUser | UserInvitedByAdmin;
    // Parse as admin or user depending on the type
    if (invitedByUser) {
      const parsedInviteFromUser = parseDynamo<UserInvite>(
        inviteQuery,
        kUserInviteParser
      );
      if (parsedInviteFromUser instanceof DynamoParseError) {
        throw new Error(parsedInviteFromUser.message);
      }
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

      const friendshipId = uuid.v4();
      const friendshipCreationDate = new Date();

      const newUserFriendship: FriendshipWithoutMessage = {
        id: friendshipId,
        createdAt: friendshipCreationDate,
        otherUser: inviter,
      };

      const inviterFriendship: FriendshipWithoutMessage = {
        id: friendshipId,
        createdAt: friendshipCreationDate,
        otherUser: newUserExplore,
      };

      transaction.puts.push({
        pk: `USER#${event.userName}`,
        sk: `FRIENDSHIP${inviter.id}`,
        data: friendshipWithoutMessageToDynamo(newUserFriendship),
      });
      transaction.puts.push({
        pk: `USER#${inviter.id}`,
        sk: `FRIENDSHIP${event.userName}`,
        data: friendshipWithoutMessageToDynamo(inviterFriendship),
      });

      // Create our newly registered user
      newUser = {
        ...newUserExplore,
        numInvites: kInitialNumInvites,
        invite: parsedInviteFromUser,
      };
    } else {
      // If the inviter is an admin, no action needed after parsing
      const parsedInviteFromAdmin = parseDynamo<AdminInvite>(
        inviteQuery,
        kAdminInviteParser
      );
      if (parsedInviteFromAdmin instanceof DynamoParseError) {
        throw new Error(parsedInviteFromAdmin.message);
      }
      // Create our newly registered user
      newUser = {
        ...newUserExplore,
        numInvites: kInitialNumInvites,
        invite: parsedInviteFromAdmin,
      };
    }

    // Add the users details to the DB
    transaction.puts.push(
      {
        pk: "USERS",
        sk: `USER#${event.userName}`,
        data: invitedByUser
          ? userInvitedByUserToDynamo(newUser as UserInvitedByUser)
          : userInvitedByAdminToDynamo(newUser as UserInvitedByAdmin),
      },
      {
        // Add the required user details to the gym PK so users can be explored/queried by gym
        pk: `GYM#${newUser.invite.gym.id}`,
        sk: `USER#${event.userName}`,
        data: userExploreToDynamo(newUser),
      }
    );

    await client.writeTransaction(transaction);
    return event;
  }
}
