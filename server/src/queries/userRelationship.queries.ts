import {
  UserRelationship,
  UserRelationshipType,
} from "../models/userRelationship.model";

export class UserRelationshipQueries {
  static async block(cognitoId: string, otherUserCognitoId: string) {
    await UserRelationship.findOneAndUpdate(
      { sender: cognitoId, recipient: otherUserCognitoId },
      { type: UserRelationshipType.Blocked },
      { upsert: true }
    );
  }

  static async sendRequest(cognitoId: string, otherUserCognitoId: string) {
    await UserRelationship.findOneAndUpdate(
      { sender: cognitoId, recipient: otherUserCognitoId },
      { type: UserRelationshipType.Requested },
      { upsert: true }
    );
  }

  static async denyRequest(cognitoId: string, otherUserCognitoId: string) {
    await UserRelationship.findOneAndUpdate(
      { sender: cognitoId, recipient: otherUserCognitoId },
      { type: UserRelationshipType.Denied },
      { upsert: true }
    );
  }
}
