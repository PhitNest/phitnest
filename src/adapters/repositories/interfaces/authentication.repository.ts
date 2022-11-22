export interface IAuthenticationRepository {
  authenticate(accessToken: string): Promise<string | undefined>;
}
