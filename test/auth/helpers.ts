import { deleteUser, login } from "../helpers";
import { testEmail, testPassword } from "./constants";

export async function cleanup() {
  return login(globalThis.app, testEmail, testPassword).then(
    (accessToken: string) => deleteUser(globalThis.app, accessToken)
  );
}
