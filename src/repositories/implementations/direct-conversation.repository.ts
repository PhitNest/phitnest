import mongoose from "mongoose";
import { IDirectConversationEntity } from "../../entities";
import { IDirectConversationRepository } from "../interfaces";

export const DIRECT_CONVERSATION_COLLECTION_NAME = "direct-conversations";
export const DIRECT_CONVERSATION_MODEL_NAME = "DirectConversation";

const schema = new mongoose.Schema({
  userCognitoIds: { type: [String], required: true },
});

schema.index({ userCognitoIds: 1 }, { unique: true });

const DirectConversationModel = mongoose.model<IDirectConversationEntity>(
  DIRECT_CONVERSATION_MODEL_NAME,
  schema
);

export class MongoDirectConversationRepository
  implements IDirectConversationRepository
{
  create(userCognitoIds: [string, string]) {
    return DirectConversationModel.create({ userCognitoIds: userCognitoIds });
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
