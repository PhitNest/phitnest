import { injectable } from "inversify";
import mongoose from "mongoose";
import { IRelationshipEntity, RelationshipType } from "../../entities";
import { IRelationshipRepository } from "../interfaces";
import { USER_COLLECTION_NAME } from "./user.repository";

export const RELATIONSHIP_COLLECTION_NAME = "relationships";
export const RELATIONSHIP_MODEL_NAME = "Relationship";

const schema = new mongoose.Schema(
  {
    sender: { type: String, required: true },
    recipient: { type: String, required: true },
    type: { type: String, enum: RelationshipType, required: true },
  },
  {
    collection: RELATIONSHIP_COLLECTION_NAME,
  }
);

schema.index({ sender: 1, recipient: 1 }, { unique: true });
schema.index({ sender: 1, type: 1 });
schema.index({ recipient: 1, type: 1 });

const RelationshipModel = mongoose.model<IRelationshipEntity>(
  RELATIONSHIP_MODEL_NAME,
  schema
);

@injectable()
export class MongoRelationshipRepository implements IRelationshipRepository {
  async createBlock(senderId: string, recipientId: string) {
    await RelationshipModel.findOneAndUpdate(
      { sender: senderId, recipient: recipientId },
      { type: RelationshipType.Blocked },
      { upsert: true, new: true }
    );
  }

  async deleteBlock(senderId: string, recipientId: string) {
    await RelationshipModel.deleteOne({
      sender: senderId,
      recipient: recipientId,
      type: RelationshipType.Blocked,
    });
  }

  async createRequest(senderId: string, recipientId: string) {
    await RelationshipModel.findOneAndUpdate(
      { sender: senderId, recipient: recipientId },
      { type: RelationshipType.Requested },
      { upsert: true, new: true }
    );
  }

  async createDeny(senderId: string, recipientId: string) {
    await RelationshipModel.findOneAndUpdate(
      { sender: senderId, recipient: recipientId },
      { type: RelationshipType.Denied },
      { upsert: true, new: true }
    );
  }

  getPendingOutboundRequests(senderId: string) {
    return RelationshipModel.aggregate([
      {
        $match: {
          sender: senderId,
          type: RelationshipType.Requested,
        },
      },
      {
        $lookup: {
          from: RELATIONSHIP_COLLECTION_NAME,
          localField: "recipient",
          foreignField: "sender",
          pipeline: [
            {
              $match: {
                recipient: senderId,
              },
            },
          ],
          as: "response",
        },
      },
      {
        $match: {
          $expr: {
            $not: {
              $gt: [
                {
                  $size: "$response",
                },
                0,
              ],
            },
          },
        },
      },
      {
        $lookup: {
          from: USER_COLLECTION_NAME,
          localField: "recipient",
          foreignField: "_id",
          as: "users",
        },
      },
      {
        $project: {
          id: {
            $first: "$users._id",
          },
          gymId: {
            $first: "$users.gymId",
          },
          firstName: {
            $first: "$users.firstName",
          },
          lastName: {
            $first: "$users.lastName",
          },
        },
      },
    ]).exec();
  }

  getPendingInboundRequests(recipientId: string) {
    return RelationshipModel.aggregate([
      {
        $match: {
          recipient: recipientId,
          type: RelationshipType.Requested,
        },
      },
      {
        $lookup: {
          from: RELATIONSHIP_COLLECTION_NAME,
          localField: "sender",
          foreignField: "recipient",
          pipeline: [
            {
              $match: {
                sender: recipientId,
              },
            },
          ],
          as: "response",
        },
      },
      {
        $match: {
          $expr: {
            $not: {
              $gt: [
                {
                  $size: "$response",
                },
                0,
              ],
            },
          },
        },
      },
      {
        $lookup: {
          from: USER_COLLECTION_NAME,
          localField: "sender",
          foreignField: "_id",
          as: "users",
        },
      },
      {
        $project: {
          id: {
            $first: "$users._id",
          },
          gymId: {
            $first: "$users.gymId",
          },
          firstName: {
            $first: "$users.firstName",
          },
          lastName: {
            $first: "$users.lastName",
          },
        },
      },
    ]).exec();
  }

  getFriends(userId: string) {
    return RelationshipModel.aggregate([
      {
        $match: {
          sender: userId,
          type: RelationshipType.Requested,
        },
      },
      {
        $lookup: {
          from: RELATIONSHIP_COLLECTION_NAME,
          localField: "recipient",
          foreignField: "sender",
          as: "friends",
          pipeline: [
            {
              $match: {
                recipient: userId,
                type: RelationshipType.Requested,
              },
            },
          ],
        },
      },
      {
        $match: {
          friends: {
            $gt: [
              {
                $size: "$friends",
              },
              0,
            ],
          },
        },
      },
      {
        $project: {
          friendId: {
            $first: "$friends.sender",
          },
        },
      },
      {
        $lookup: {
          from: USER_COLLECTION_NAME,
          localField: "friendId",
          foreignField: "_id",
          as: "friend",
        },
      },
      {
        $project: {
          id: {
            $first: "$friend._id",
          },
          gymId: {
            $first: "$friend.gymId",
          },
          firstName: {
            $first: "$friend.firstName",
          },
          lastName: {
            $first: "$friend.lastName",
          },
        },
      },
    ]).exec();
  }
}
