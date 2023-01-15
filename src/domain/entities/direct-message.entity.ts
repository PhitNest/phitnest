export interface IDirectMessageEntity {
  _id: string;
  text: string;
  senderCognitoId: string;
  friendshipId: string;
  createdAt: Date;
}
