import Auth, { kCognitoCredentials } from "./auth";

describe("Mocking Cognito Identity Provider", () => {
  it("Register should return a random uuid v4", async () => {
    const body = {
      email: "test@gmail.com",
      password: "password",
      firstName: "John",
      lastName: "Doe",
    };
    expect(
      await Auth.register(
        body.email,
        body.password,
        body.firstName,
        body.lastName
      )
    ).toMatch(
      /^[0-9A-F]{8}-[0-9A-F]{4}-[4][0-9A-F]{3}-[89AB][0-9A-F]{3}-[0-9A-F]{12}$/i
    );
  });

  it("User pool should not be loaded in CI", async () => {
    expect(kCognitoCredentials).toEqual({
      userPoolId: "sandbox",
      clientId: "sandbox",
    });
  });
});
