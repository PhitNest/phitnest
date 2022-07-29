const supertest = require("supertest");
const jwt = require("jsonwebtoken");
const { userCachePrefix } = require("../../../lib/constants");

module.exports = () => {
  const validUser = globalThis.data.createdUser;
  const validUserRedisKey = `${userCachePrefix}/${validUser._id}`;

  it("Invalid request", async () => {
    await supertest(globalThis.app)
      .post("/auth/login")
      .send({
        notEmail: "a@b.com",
        notPassword: "aaaaaa",
      })
      .expect(400);
  });

  it("Non-existing user", async () => {
    await supertest(globalThis.app)
      .post("/auth/login")
      .send({
        email: "a@a.com",
        password: "aaaaaa",
      })
      .expect(404);
  });

  it("Incorrect password", async () => {
    await supertest(globalThis.app)
      .post("/auth/login")
      .send({
        email: "a@b.com",
        password: "bbbbbb",
      })
      .expect(400);
  });

  it("User should not be cached", async () => {
    expect(await globalThis.redis.get(validUserRedisKey)).toBe(null);
  });

  it("Correct password", async () => {
    await supertest(globalThis.app)
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
      .expect(200);
  });

  it("User should be cached", async () => {
    expect(JSON.parse(await globalThis.redis.get(validUserRedisKey))._id).toBe(
      validUser._id.toString()
    );
  });
};
