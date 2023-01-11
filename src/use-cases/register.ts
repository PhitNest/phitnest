import { authRepository } from "../repositories/injection";

export async function registerUser(user: {
  email: string;
  firstName: string;
  lastName: string;
  gymId: string;
  password: string;
}) {
  const authRepo = authRepository();
  const cognitoRegistration = await authRepo.registerUser(
    user.email,
    user.password
  );
  return cognitoRegistration.
}
