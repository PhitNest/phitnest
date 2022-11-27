export enum RelationshipType {
  Requested = "Requested",
  Denied = "Denied",
  Blocked = "Blocked",
}

export interface IRelationshipEntity {
  _id: string;
  sender: string;
  recipient: string;
  type: RelationshipType;
}
