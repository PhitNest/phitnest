export interface IMessageEntity {
  _id: string;
  text: string;
  senderCognitoId: string;
  conversationId: string;
}
