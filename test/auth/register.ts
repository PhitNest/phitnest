import supertest, { Response } from "supertest";
import { testEmail, testPassword } from "./constants";
import { cleanup } from "./helpers";

export default () => {
  test("Register request with no body", () =>
    supertest(globalThis.app).post("/auth/register").send().expect(415));

  test("Register request with invalid body", () =>
    supertest(globalThis.app).post("/auth/register").send({}).expect(400));

  test("Register a new user", () =>
    supertest(globalThis.app)
      .post("/auth/register")
      .send({
        email: testEmail,
        gymId: globalThis.gymIds[0],
        password: testPassword,
        firstName: "Joe",
        lastName: "James",
      })
      .expect(200));

  test("Registering an existing user should result in error", () =>
    supertest(globalThis.app)
      .post("/auth/register")
      .send({
        email: testEmail,
        gymId: globalThis.gymIds[0],
        password: testPassword,
        firstName: "Joe",
        lastName: "James",
      })
      .expect(500)
      .then((res: Response) => cleanup()));
};
