import dataSources from "../../data/data-sources/injection";

class AuthRepository {
  getCognitoId(accessToken: string) {
    return dataSources().authDatabase.getCognitoId(accessToken);
  }

  refreshSession(refreshToken: string, email: string) {
    return dataSources().authDatabase.refreshSession(refreshToken, email);
  }

  deleteUser(cognitoId: string) {
    return dataSources().authDatabase.deleteUser(cognitoId);
  }

  registerUser(email: string, password: string) {
    return dataSources().authDatabase.registerUser(email, password);
  }

  signOut(accessToken: string) {
    return dataSources().authDatabase.signOut(accessToken);
  }

  forgotPassword(email: string) {
    return dataSources().authDatabase.forgotPassword(email);
  }

  forgotPasswordSubmit(email: string, code: string, newPassword: string) {
    return dataSources().authDatabase.forgotPasswordSubmit(
      email,
      code,
      newPassword
    );
  }

  confirmRegister(email: string, code: string) {
    return dataSources().authDatabase.confirmRegister(email, code);
  }

  login(email: string, password: string) {
    return dataSources().authDatabase.login(email, password);
  }

  resendConfirmationCode(email: string) {
    return dataSources().authDatabase.resendConfirmationCode(email);
  }
}

export const authRepo = new AuthRepository();
