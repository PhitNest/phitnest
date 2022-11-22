import { IAuthenticationRepository } from "../../adapters/repositories/interfaces";

export type AuthenticationUseCase = (
  accessToken: string
) => Promise<string | undefined>;

export function buildAuthenticationUseCase(
  authenticationRepository: IAuthenticationRepository
): AuthenticationUseCase {
  return function (accessToken) {
    return authenticationRepository.authenticate(accessToken);
  };
}
