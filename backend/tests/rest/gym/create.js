const supertest = require("supertest");
const { StatusBadRequest, StatusOK } = require("../../../lib/constants");

const _ = require("lodash");

const gyms = [
  {
    name: "Planet Fitness",
    address: {
      street: "44 Maine St",
      city: "Ashland",
      state: "Ohio",
      zipCode: "44805",
    },
  },
  {
    name: "Planet Fitness",
    address: {
      street: "131 Iroquois St",
      city: "Struthers",
      state: "Ohio",
      zipCode: "44471",
    },
  },
  {
    name: "24 Hour Fitness",
    address: {
      street: "811 Ercama St",
      city: "Linden",
      state: "New Jersey",
      zipCode: "07036",
    },
  },
];

module.exports = () => {
  test("Missing body", () =>
    supertest(globalThis.app).post("/gym").send().expect(StatusBadRequest));

  test("Missing name", () =>
    supertest(globalThis.app)
      .post("/gym")
      .send(_.omit(gyms[0], "name"))
      .expect(StatusBadRequest));

  test("Missing street", () =>
    supertest(globalThis.app)
      .post("/gym")
      .send(_.omit(gyms[0], "address.street"))
      .expect(StatusBadRequest));

  test("Missing city", () =>
    supertest(globalThis.app)
      .post("/gym")
      .send(_.omit(gyms[0], "address.city"))
      .expect(StatusBadRequest));

  test("Missing state", () =>
    supertest(globalThis.app)
      .post("/gym")
      .send(_.omit(gyms[0], "address.state"))
      .expect(StatusBadRequest));

  test("Missing zipcode", () =>
    supertest(globalThis.app)
      .post("/gym")
      .send(_.omit(gyms[0], "address.zipCode"))
      .expect(StatusBadRequest));

  test("Fake address", () =>
    supertest(globalThis.app)
      .post("/gym")
      .send({
        name: "Test",
        address: {
          street: "123 Sesame St",
          city: "Dakota",
          State: "Ireland",
          zipCode: "123",
        },
      })
      .expect(StatusBadRequest));

  test("Valid gym creation", async () => {
    for (let i = 0; i < gyms.length; i++) {
      supertest(globalThis.app)
        .post("/gym")
        .send(gyms[i])
        .expect(StatusOK)
        .expect((res) => expect(JSON.parse(res.text).id).toBe(i.toString()));
    }
  });
};
