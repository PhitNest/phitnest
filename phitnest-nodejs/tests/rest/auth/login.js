const supertest = require("supertest");
const jwt = require("jsonwebtoken");
const { userCachePrefix } = require("../../../lib/constants");

module.exports = () => {
  const validUser = globalThis.data.createdUser;
  const validUserRedisKey = `${userCachePrefix}/${validUser._id}`;

  test("Missing password", () =>
    supertest(globalThis.app)
      .post("/auth/login")
      .send({
        email: "a@b.com",
        notPassword: "aaaaaa",
      })
      .expect(400));

  test("Missing email", () =>
    supertest(globalThis.app)
      .post("/auth/login")
      .send({
        notEmail: "a@b.com",
        password: "aaaaaa",
      })
      .expect(400));

  test("Non-existing user", () =>
    supertest(globalThis.app)
      .post("/auth/login")
      .send({
        email: "a@a.com",
        password: "aaaaaa",
      })
      .expect(404));

  test("Incorrect password", () =>
    supertest(globalThis.app)
      .post("/auth/login")
      .send({
        email: "a@b.com",
        password: "bbbbbb",
      })
      .expect(400));

  test("User should not be cached", () =>
    globalThis.redis
      .get(validUserRedisKey)
      .then((value) => expect(value).toBe(null)));

  test("Correct password", () =>
    supertest(globalThis.app)
      .post("/auth/login")
      .send({
        email: "a@b.com",
        password: "aaaaaa",
      })
      .expect((res) =>
        expect(jwt.verify(res.text, globalThis.jwtSecret)._id).toBe(
          validUser._id.toString()
        )
      )
      .expect(200));

  test("User should be cached", () =>
    globalThis.redis
      .get(validUserRedisKey)
      .then((value) =>
        expect(JSON.parse(value)._id).toBe(validUser._id.toString())
      ));
};
