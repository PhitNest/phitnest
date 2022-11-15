import supertest from "supertest";

export default () => {
  test("Login request with no body", () =>
    supertest(globalThis.app).post("/auth/login").send().expect(415));

  test("Login request with invalid body", () =>
    supertest(globalThis.app).post("/auth/login").send({}).expect(400));
};
