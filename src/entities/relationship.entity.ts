export enum RelationshipType {
  Requested = "Requested",
  Denied = "Denied",
  Blocked = "Blocked",
}

export interface IRelationshipEntity {
  id: string;
  sender: string;
  recipient: string;
  type: RelationshipType;
}
