export interface IFriendRequestEntity {
  _id: string;
  fromCognitoId: string;
  toCognitoId: string;
  createdAt: Date;
}
