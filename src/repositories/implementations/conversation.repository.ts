import mongoose from "mongoose";
import { IConversationEntity } from "../../entities";
import { IConversationRepository } from "../interfaces";

export const CONVERSATION_COLLECTION_NAME = "conversations";
export const CONVERSATION_MODEL_NAME = "Conversation";

import { MESSAGE_COLLECTION_NAME } from "./message.repository";
import { USER_COLLECTION_NAME } from "./user.repository";

const schema = new mongoose.Schema(
  {
    users: { type: [String], required: true },
    archived: { type: Boolean, default: false },
  },
  {
    collection: CONVERSATION_COLLECTION_NAME,
  }
);

schema.index({ users: 1 });

const ConversationModel = mongoose.model<IConversationEntity>(
  CONVERSATION_MODEL_NAME,
  schema
);

export class MongoConversationRepository implements IConversationRepository {
  async deleteAll() {
    await ConversationModel.deleteMany({}).exec();
  }

  async archive(conversationId: string) {
    await ConversationModel.findByIdAndUpdate(conversationId, {
      archived: true,
    });
  }

  async isUserInConversation(userCognitoId: string, conversationId: string) {
    return (
      (await ConversationModel.findById(conversationId))?.users.includes(
        userCognitoId
      ) ?? false
    );
  }

  getRecentMessages(cognitoId: string) {
    return ConversationModel.aggregate([
      {
        $match: {
          users: cognitoId,
          archived: false,
        },
      },
      {
        $lookup: {
          from: MESSAGE_COLLECTION_NAME,
          localField: "_id",
          foreignField: "conversationId",
          as: "recentMessage",
        },
      },
      { $unwind: "$recentMessage" },
      { $sort: { "recentMessage.createdAt": -1 } },
      {
        $project: {
          conversation: {
            _id: "$_id",
            users: "$users",
          },
          message: "$recentMessage",
        },
      },
      {
        $group: {
          _id: "$conversation._id",
          conversation: {
            $first: "$conversation",
          },
          message: {
            $first: "$message",
          },
        },
      },
      {
        $lookup: {
          from: USER_COLLECTION_NAME,
          localField: "conversation.users",
          foreignField: "cognitoId",
          as: "users",
        },
      },
      {
        $project: {
          message: 1,
          "conversation._id": "$conversation._id",
          "conversation.users": "$users",
        },
      },
      {
        $sort: {
          "message.createdAt": -1,
        },
      },
    ]).exec();
  }

  create(userCognitoIds: string[]) {
    return ConversationModel.create({ users: userCognitoIds });
  }

  getByUser(cognitoId: string) {
    return ConversationModel.aggregate([
      {
        $match: {
          users: cognitoId,
          archived: false,
        },
      },
    ]).exec();
  }

  getByUsers(cognitoIds: string[]) {
    return ConversationModel.findOne({
      users: {
        $all: cognitoIds,
      },
      archived: false,
    }).exec();
  }
}
