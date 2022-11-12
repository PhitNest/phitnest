import "mocha";
import request from "supertest";
import { expect } from "chai";
import Server from "../server";
import { produceAccessToken } from "./helpers";
import { testUser, testUser2, testUser3 } from "./constants";
import { IUserModel } from "../server/src/models/user.model";
import { fail } from "assert";

function compareData(user: any, expected: IUserModel) {
  expect(user.cognitoId).equals(expected.cognitoId);
  expect(user.gymId).equals(expected.gymId.toString());
  expect(user.firstName).equals(expected.firstName);
  expect(user.lastName).equals(expected.lastName);
}

produceAccessToken(testUser, (accessToken1) => {
  produceAccessToken(testUser2, (accessToken2) => {
    produceAccessToken(testUser3, (accessToken3) => {
      const header1 = `Bearer ${accessToken1}`;
      const header2 = `Bearer ${accessToken2}`;
      const header3 = `Bearer ${accessToken3}`;
      describe("Requesting my friends", () => {
        it("should deny my request without an access token", () =>
          request(Server).get("/userRelationship/friends").expect(401));

        it("should accept my request with an access token", () =>
          request(Server)
            .get("/userRelationship/friends")
            .set("Authorization", header1)
            .send()
            .expect(200)
            .then((res: request.Response) => {
              expect(res.body.length).equal(0);
            }));
      });

      describe("Sending a friend request", () => {
        it("should deny my request without an access token", () =>
          request(Server)
            .post("/userRelationship/sendRequest")
            .send({
              recipientId: testUser2.cognitoId,
            })
            .expect(401));

        it("should accept my request with an access token", () =>
          request(Server)
            .post("/userRelationship/sendRequest")
            .set("Authorization", header1)
            .send({
              recipientId: testUser2.cognitoId,
            })
            .expect(200));

        it("should not immediately result in friendship for sender", () =>
          request(Server)
            .get("/userRelationship/friends")
            .set("Authorization", header1)
            .send()
            .expect(200)
            .then((res: request.Response) => {
              expect(res.body.length).equals(0);
            }));

        it("should not immediately result in friendship for recipient", () =>
          request(Server)
            .get("/userRelationship/friends")
            .set("Authorization", header2)
            .send()
            .expect(200)
            .then((res: request.Response) => {
              expect(res.body.length).equals(0);
            }));

        it("should be able to accept the friend request", () =>
          request(Server)
            .post("/userRelationship/sendRequest")
            .set("Authorization", header2)
            .send({
              recipientId: testUser.cognitoId,
            })
            .expect(200));

        it("should result in friendship for sender", () =>
          request(Server)
            .get("/userRelationship/friends")
            .set("Authorization", header1)
            .send()
            .expect(200)
            .then((res: request.Response) => {
              expect(res.body.length).equals(1);
              compareData(res.body[0], testUser2);
            }));

        it("should result in friendship for recipient", () =>
          request(Server)
            .get("/userRelationship/friends")
            .set("Authorization", header2)
            .send()
            .expect(200)
            .then((res: request.Response) => {
              expect(res.body.length).equals(1);
              compareData(res.body[0], testUser);
            }));

        it("accept the request a second time", () =>
          request(Server)
            .post("/userRelationship/sendRequest")
            .set("Authorization", header2)
            .send({
              recipientId: testUser.cognitoId,
            })
            .expect(200));

        it("should be a no-op", () =>
          request(Server)
            .get("/userRelationship/friends")
            .set("Authorization", header2)
            .send()
            .expect(200)
            .then((res: request.Response) => {
              expect(res.body.length).equals(1);
              compareData(res.body[0], testUser);
            }));

        it("Send another friend request", () =>
          request(Server)
            .post("/userRelationship/sendRequest")
            .set("Authorization", header2)
            .send({
              recipientId: testUser3.cognitoId,
            })
            .expect(200));

        it("should not immediately result in friendship", () =>
          request(Server)
            .get("/userRelationship/friends")
            .set("Authorization", header2)
            .send()
            .expect(200)
            .then((res: request.Response) => {
              expect(res.body.length).equals(1);
              compareData(res.body[0], testUser);
            }));

        it("Deny the friend request", () =>
          request(Server)
            .post("/userRelationship/denyRequest")
            .set("Authorization", header3)
            .send({
              recipientId: testUser2.cognitoId,
            })
            .expect(200));

        it("should result in no friendship", () =>
          request(Server)
            .get("/userRelationship/friends")
            .set("Authorization", header2)
            .send()
            .expect(200)
            .then((res: request.Response) => {
              expect(res.body.length).equals(1);
              compareData(res.body[0], testUser);
            }));

        it("Accept the friend request", () =>
          request(Server)
            .post("/userRelationship/sendRequest")
            .set("Authorization", header3)
            .send({
              recipientId: testUser2.cognitoId,
            })
            .expect(200));

        it("should result in friendship", () =>
          request(Server)
            .get("/userRelationship/friends")
            .set("Authorization", header2)
            .send()
            .expect(200)
            .then((res: request.Response) => {
              expect(res.body.length).equals(2);
              if (res.body[0].cognitoId == testUser.cognitoId) {
                compareData(res.body[0], testUser);
                compareData(res.body[1], testUser3);
              } else if (res.body[1].cognitoId == testUser.cognitoId) {
                compareData(res.body[0], testUser3);
                compareData(res.body[1], testUser);
              } else {
                fail();
              }
            }));

        it("should result in friendship", () =>
          request(Server)
            .get("/userRelationship/friends")
            .set("Authorization", header3)
            .send()
            .expect(200)
            .then((res: request.Response) => {
              expect(res.body.length).equals(1);
              compareData(res.body[0], testUser2);
            }));

        it("Cancel the friend request", () =>
          request(Server)
            .post("/userRelationship/denyRequest")
            .set("Authorization", header3)
            .send({
              recipientId: testUser2.cognitoId,
            })
            .expect(200));

        it("should result in no friendship", () =>
          request(Server)
            .get("/userRelationship/friends")
            .set("Authorization", header2)
            .send()
            .expect(200)
            .then((res: request.Response) => {
              expect(res.body.length).equals(1);
              compareData(res.body[0], testUser);
            }));

        it("should result in no friendship", () =>
          request(Server)
            .get("/userRelationship/friends")
            .set("Authorization", header3)
            .send()
            .expect(200)
            .then((res: request.Response) => {
              expect(res.body.length).equals(0);
            }));
      });
    });
  });
});
