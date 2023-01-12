export interface IUserEntity {
  _id: string;
  cognitoId: string;
  gymId: string;
  email: string;
  firstName: string;
  lastName: string;
  confirmed: boolean;
}

export type ICognitoUser = Omit<IUserEntity, "_id" | "confirmed">;

export type IPublicUserEntity = Omit<IUserEntity, "email">;
