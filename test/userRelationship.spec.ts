import "mocha";
import request from "supertest";
import { expect } from "chai";
import Server from "../server";
import { produceAccessToken, comparePublicData } from "./helpers";
import { testUsers } from "./constants";
import { fail } from "assert";
import { clear } from "./setup";

produceAccessToken(testUsers[0], (accessToken1) => {
  produceAccessToken(testUsers[1], (accessToken2) => {
    produceAccessToken(testUsers[2], (accessToken3) => {
      describe("User Relationship Suite", () => {
        clear();
        const header1 = `Bearer ${accessToken1}`;
        const header2 = `Bearer ${accessToken2}`;
        const header3 = `Bearer ${accessToken3}`;
        it("should deny my request without an access token", () =>
          request(Server).get("/userRelationship/friends").expect(401));

        it("should not accept my request with access token for pending friend requests", () =>
          request(Server).get("/userRelationship/sentRequests").expect(401));

        it("should accept my request with access token for pending friend requests", () =>
          request(Server)
            .get("/userRelationship/sentRequests")
            .set("Authorization", header1)
            .expect(200)
            .then((res: request.Response) => {
              expect(res.body.length).equal(0);
            }));

        it("should accept my request with an access token", () =>
          request(Server)
            .get("/userRelationship/friends")
            .set("Authorization", header1)
            .send()
            .expect(200)
            .then((res: request.Response) => {
              expect(res.body.length).equal(0);
            }));

        it("should deny my request without an access token", () =>
          request(Server)
            .post("/userRelationship/sendRequest")
            .send({
              recipientId: testUsers[1].cognitoId,
            })
            .expect(401));

        it("should accept my request with an access token", () =>
          request(Server)
            .post("/userRelationship/sendRequest")
            .set("Authorization", header1)
            .send({
              recipientId: testUsers[1].cognitoId,
            })
            .expect(200));

        it("should show one pending request", () =>
          request(Server)
            .get("/userRelationship/sentRequests")
            .set("Authorization", header1)
            .expect(200)
            .then((res: request.Response) => {
              expect(res.body.length).equal(1);
              comparePublicData(res.body[0], testUsers[1]);
            }));

        it("should show one pending request", () =>
          request(Server)
            .get("/userRelationship/receivedRequests")
            .set("Authorization", header2)
            .expect(200)
            .then((res: request.Response) => {
              expect(res.body.length).equal(1);
              comparePublicData(res.body[0], testUsers[0]);
            }));

        it("should show no pending requests", () =>
          request(Server)
            .get("/userRelationship/receivedRequests")
            .set("Authorization", header1)
            .expect(200)
            .then((res: request.Response) => {
              expect(res.body.length).equal(0);
            }));

        it("sending to an invalid id", () =>
          request(Server)
            .post("/userRelationship/sendRequest")
            .set("Authorization", header1)
            .send({
              recipientId: "abcd",
            })
            .expect(500));

        it("should show one pending request", () =>
          request(Server)
            .get("/userRelationship/sentRequests")
            .set("Authorization", header1)
            .expect(200)
            .then((res: request.Response) => {
              expect(res.body.length).equal(1);
              comparePublicData(res.body[0], testUsers[1]);
            }));

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

        it("should show no pending requests", () =>
          request(Server)
            .get("/userRelationship/sentRequests")
            .set("Authorization", header2)
            .expect(200)
            .then((res: request.Response) => {
              expect(res.body.length).equal(0);
            }));

        it("should show no pending requests", () =>
          request(Server)
            .get("/userRelationship/receivedRequests")
            .set("Authorization", header1)
            .expect(200)
            .then((res: request.Response) => {
              expect(res.body.length).equal(0);
            }));

        it("should be able to accept the friend request", () =>
          request(Server)
            .post("/userRelationship/sendRequest")
            .set("Authorization", header2)
            .send({
              recipientId: testUsers[0].cognitoId,
            })
            .expect(200));

        it("should show no pending requests after accepting friend request", () =>
          request(Server)
            .get("/userRelationship/receivedRequests")
            .set("Authorization", header2)
            .expect(200)
            .then((res: request.Response) => {
              expect(res.body.length).equal(0);
            }));

        it("should show no pending requests after accepting friend request", () =>
          request(Server)
            .get("/userRelationship/receivedRequests")
            .set("Authorization", header1)
            .expect(200)
            .then((res: request.Response) => {
              expect(res.body.length).equal(0);
            }));

        it("should show no pending request after it has been accepted", () =>
          request(Server)
            .get("/userRelationship/sentRequests")
            .set("Authorization", header1)
            .expect(200)
            .then((res: request.Response) => {
              expect(res.body.length).equal(0);
            }));

        it("should result in friendship for sender", () =>
          request(Server)
            .get("/userRelationship/friends")
            .set("Authorization", header1)
            .send()
            .expect(200)
            .then((res: request.Response) => {
              expect(res.body.length).equals(1);
              comparePublicData(res.body[0], testUsers[1]);
            }));

        it("should result in friendship for recipient", () =>
          request(Server)
            .get("/userRelationship/friends")
            .set("Authorization", header2)
            .send()
            .expect(200)
            .then((res: request.Response) => {
              expect(res.body.length).equals(1);
              comparePublicData(res.body[0], testUsers[0]);
            }));

        it("accept the request a second time", () =>
          request(Server)
            .post("/userRelationship/sendRequest")
            .set("Authorization", header2)
            .send({
              recipientId: testUsers[0].cognitoId,
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
              comparePublicData(res.body[0], testUsers[0]);
            }));

        it("Send another friend request", () =>
          request(Server)
            .post("/userRelationship/sendRequest")
            .set("Authorization", header2)
            .send({
              recipientId: testUsers[2].cognitoId,
            })
            .expect(200));

        it("should show a pending request", () =>
          request(Server)
            .get("/userRelationship/sentRequests")
            .set("Authorization", header2)
            .expect(200)
            .then((res: request.Response) => {
              expect(res.body.length).equal(1);
              comparePublicData(res.body[0], testUsers[2]);
            }));

        it("should show a pending request", () =>
          request(Server)
            .get("/userRelationship/receivedRequests")
            .set("Authorization", header3)
            .expect(200)
            .then((res: request.Response) => {
              expect(res.body.length).equal(1);
              comparePublicData(res.body[0], testUsers[1]);
            }));

        it("should show no pending requests", () =>
          request(Server)
            .get("/userRelationship/receivedRequests")
            .set("Authorization", header2)
            .expect(200)
            .then((res: request.Response) => {
              expect(res.body.length).equal(0);
            }));

        it("should show no pending requests", () =>
          request(Server)
            .get("/userRelationship/sentRequests")
            .set("Authorization", header3)
            .expect(200)
            .then((res: request.Response) => {
              expect(res.body.length).equal(0);
            }));

        it("Send a friend request to yourself should be an error", () =>
          request(Server)
            .post("/userRelationship/sendRequest")
            .set("Authorization", header2)
            .send({
              recipientId: testUsers[1].cognitoId,
            })
            .expect(500));

        it("should not immediately result in friendship", () =>
          request(Server)
            .get("/userRelationship/friends")
            .set("Authorization", header2)
            .send()
            .expect(200)
            .then((res: request.Response) => {
              expect(res.body.length).equals(1);
              comparePublicData(res.body[0], testUsers[0]);
            }));

        it("Deny the friend request", () =>
          request(Server)
            .post("/userRelationship/denyRequest")
            .set("Authorization", header3)
            .send({
              recipientId: testUsers[1].cognitoId,
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
              comparePublicData(res.body[0], testUsers[0]);
            }));

        it("Accept the friend request", () =>
          request(Server)
            .post("/userRelationship/sendRequest")
            .set("Authorization", header3)
            .send({
              recipientId: testUsers[1].cognitoId,
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
              if (res.body[0].cognitoId == testUsers[0].cognitoId) {
                comparePublicData(res.body[0], testUsers[0]);
                comparePublicData(res.body[1], testUsers[2]);
              } else if (res.body[1].cognitoId == testUsers[0].cognitoId) {
                comparePublicData(res.body[0], testUsers[2]);
                comparePublicData(res.body[1], testUsers[0]);
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
              comparePublicData(res.body[0], testUsers[1]);
            }));

        it("Cancel the friend request", () =>
          request(Server)
            .post("/userRelationship/denyRequest")
            .set("Authorization", header3)
            .send({
              recipientId: testUsers[1].cognitoId,
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
              comparePublicData(res.body[0], testUsers[0]);
            }));

        it("should show no pending requests", () =>
          request(Server)
            .get("/userRelationship/sentRequests")
            .set("Authorization", header2)
            .expect(200)
            .then((res: request.Response) => {
              expect(res.body.length).equal(0);
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
