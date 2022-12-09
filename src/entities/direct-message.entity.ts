export interface IDirectMessageEntity {
  _id: string;
  text: string;
  senderCognitoId: string;
  conversationId: string;
}
