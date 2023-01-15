export interface IAuthEntity {
  accessToken: string;
  refreshToken: string;
  idToken: string;
}

export type IRefreshSessionEntity = Omit<IAuthEntity, "refreshToken">;
