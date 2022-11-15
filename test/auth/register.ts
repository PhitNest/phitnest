import supertest, { Response } from "supertest";
import { getHeader } from "../helpers";

const testEmail = "jp@phitnest.com";
const testPassword = "H3llOW0RLD$$";

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

  let accessToken: string;

  test("Login to the new user", () =>
    supertest(globalThis.app)
      .post("/auth/login")
      .send({
        email: testEmail,
        password: testPassword,
      })
      .expect(200)
      .then((res: Response) => {
        accessToken = res.body.accessToken;
      }));

  test("Cleanup", () =>
    supertest(globalThis.app)
      .delete("/user")
      .set("Authorization", getHeader(accessToken))
      .expect(200));
};
