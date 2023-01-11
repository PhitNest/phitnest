export interface IFriendshipEntity {
  _id: string;
  userCognitoIds: [string, string];
  createdAt: Date;
}
