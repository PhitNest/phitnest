import { Failure } from "@/common/failure";
import { kMockLoginResponse, login, register } from "./auth";

describe("Mocking Cognito Identity Provider", () => {
  it("login should return mock tokens", async () => {
    const body = {
      email: "test@gmail.com",
      password: "password",
    };
    expect(await login(body.email, body.password)).toBe(kMockLoginResponse);
  });

  it("register should return a random uuid", async () => {
    const body = {
      email: "test@gmail.com",
      password: "password",
      firstName: "John",
      lastName: "Doe",
    };
    expect(
      (await register(
        body.email,
        body.password,
        body.firstName,
        body.lastName
      )) instanceof Failure
    ).toBeFalsy();
  });
});
