import supertest from "supertest";
import { createUser, deleteUser, login } from "../helpers";
import { testEmail, testPassword } from "./constants";
import { cleanup } from "./helpers";

export default () => {
  test("Login request with no body", () =>
    supertest(globalThis.app).post("/auth/login").send().expect(415));

  test("Login request with invalid body", () =>
    supertest(globalThis.app).post("/auth/login").send({}).expect(400));

  test("Login with invalid credentials", () =>
    createUser(
      globalThis.app,
      testEmail,
      globalThis.gymIds[0],
      testPassword,
      "Joe",
      "James"
    ).then(() =>
      supertest(globalThis.app)
        .post("/auth/login")
        .send({ email: "jp@wrongemai.com", password: "incorrectPassword123$$" })
        .expect(500)
    ));

  test("Login with the correct credentials", cleanup);
};
