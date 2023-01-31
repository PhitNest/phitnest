import { Failure } from "../../common/types";
import { authRepo, userRepo } from "../repositories";

export async function login(email: string, password: string) {
  const session = await authRepo.login(email, password);
  if (session instanceof Failure) {
    return session;
  } else {
    const user = await userRepo.getByEmail(email);
    if (user instanceof Failure) {
      return user;
    } else {
      return {
        ...session,
        user: user,
      };
    }
  }
}
