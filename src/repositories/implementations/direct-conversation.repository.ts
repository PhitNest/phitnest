import mongoose from "mongoose";
import {
  IDirectConversationEntity,
  IDirectMessageEntity,
} from "../../entities";
import { IDirectConversationRepository } from "../interfaces";

export const DIRECT_CONVERSATION_COLLECTION_NAME = "direct-conversations";
export const DIRECT_CONVERSATION_MODEL_NAME = "DirectConversation";

import { DIRECT_MESSAGE_COLLECTION_NAME } from "./direct-message.repository";

const schema = new mongoose.Schema(
  {
    userCognitoIds: { type: [String], required: true },
  },
  {
    collection: DIRECT_CONVERSATION_COLLECTION_NAME,
  }
);

schema.index({ userCognitoIds: 1 }, { unique: true });

const DirectConversationModel = mongoose.model<IDirectConversationEntity>(
  DIRECT_CONVERSATION_MODEL_NAME,
  schema
);

export class MongoDirectConversationRepository
  implements IDirectConversationRepository
{
  getRecentMessages(cognitoId: string) {
    return DirectConversationModel.aggregate([
      {
        $match: {
          userCognitoIds: cognitoId,
        },
      },
      {
        $lookup: {
          from: DIRECT_MESSAGE_COLLECTION_NAME,
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
            userCognitoIds: "$userCognitoIds",
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
    ]).exec();
  }

  create(userCognitoIds: [string, string]) {
    return DirectConversationModel.create({ userCognitoIds: userCognitoIds });
  }

  async delete(conversationId: string) {
    return (
      (await DirectConversationModel.deleteOne({ _id: conversationId }).exec())
        .deletedCount > 0
    );
  }

  getByUser(cognitoId: string) {
    return DirectConversationModel.find({
      userCognitoIds: cognitoId,
    }).exec();
  }

  getByUsers(cognitoIds: [string, string]) {
    return DirectConversationModel.findOne({
      userCognitoIds: {
        $all: cognitoIds,
      },
    }).exec();
  }
}
