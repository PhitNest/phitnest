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
  },
  {
    collection: CONVERSATION_COLLECTION_NAME,
  }
);

schema.index({ userCognitoIds: 1 }, { unique: true });

const ConversationModel = mongoose.model<IConversationEntity>(
  CONVERSATION_MODEL_NAME,
  schema
);

export class MongoConversationRepository implements IConversationRepository {
  async deleteAll() {
    await ConversationModel.deleteMany({}).exec();
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
        },
      },
      {
        $lookup: {
          from: MESSAGE_COLLECTION_NAME,
          let: { conversationId: "$conversationId" },
          pipeline: [{ $match: { $expr: [{ _id: "$$conversationId" }] } }],
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
    ]).exec();
  }

  create(userCognitoIds: string[]) {
    return ConversationModel.create({ users: userCognitoIds });
  }

  async delete(conversationId: string) {
    return (
      (await ConversationModel.deleteOne({ _id: conversationId }).exec())
        .deletedCount > 0
    );
  }

  getByUser(cognitoId: string) {
    return ConversationModel.find({
      users: cognitoId,
    }).exec();
  }

  getByUsers(cognitoIds: string[]) {
    return ConversationModel.findOne({
      users: {
        $all: cognitoIds,
      },
    }).exec();
  }
}
