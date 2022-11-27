export interface IUserEntity {
  _id: string;
  cognitoId: string;
  gymId: string;
  email: string;
  firstName: string;
  lastName: string;
}

export type IPublicUserEntity = Omit<IUserEntity, "email">;
