import { Failure } from "../common/types";
import repositories from "../repositories/injection";

export async function login(email: string, password: string) {
  const { authRepo, userRepo } = repositories();
  const session = await authRepo.login(email, password);
  if (session instanceof Failure) {
    return session;
  } else {
    const user = await userRepo.getByEmail(email);
    if (user instanceof Failure) {
      return user;
    } else {
      return {
        session: session,
        user: user,
      };
    }
  }
}
