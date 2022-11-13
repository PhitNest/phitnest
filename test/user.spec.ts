import "mocha";
import request from "supertest";
import { expect } from "chai";
import Server from "../server";
import { produceAccessToken, comparePublicData } from "./helpers";
import { testUsers } from "./constants";
import { clear } from "./setup";

const testUser = testUsers[0];
const otherUser = testUsers[2];

produceAccessToken(testUser, (accessToken) => {
  produceAccessToken(otherUser, (otherAccessToken) => {
    describe("User Suite", () => {
      clear();
      const header = `Bearer ${accessToken}`;
      const otherHeader = `Bearer ${otherAccessToken}`;
      it("should not return my user data without an access token", () =>
        request(Server).get("/user").expect(401));

      it("should return my user data with an access token", () =>
        request(Server)
          .get("/user")
          .set("Authorization", header)
          .expect(200)
          .then((res: request.Response) => {
            expect(res.body.gymId).equal(testUser.gymId.toString());
            expect(res.body.cognitoId).equal(testUser.cognitoId);
            expect(res.body.firstName).equal(testUser.firstName);
            expect(res.body.lastName).equal(testUser.lastName);
          }));

      describe("Explore", () => {
        it("should deny my request without an access token", () =>
          request(Server).get("/user/explore").expect(401));

        it("should deny my request if there is no parameters", () =>
          request(Server)
            .get("/user/explore")
            .set("Authorization", header)
            .expect(400));

        it("should deny my request if the limit is too high", () =>
          request(Server)
            .get("/user/explore")
            .set("Authorization", header)
            .query({ offset: 0, limit: 51 })
            .expect(400));

        it("should find everyone at my gym 1", () =>
          request(Server)
            .get("/user/explore")
            .query({ offset: 0, limit: 50 })
            .set("Authorization", header)
            .expect(200)
            .then((res: request.Response) => {
              expect(res.body.length).equal(4);
              for (let i = 0; i < 4; i++) {
                for (let k = 0; k < 4; k++) {
                  if (res.body[k].cognitoId == testUsers[i].cognitoId) {
                    comparePublicData(res.body[k], testUsers[i]);
                  }
                }
              }
            }));

        it("Send a friend request", () =>
          request(Server)
            .post("/userRelationship/sendRequest")
            .set("Authorization", header)
            .send({
              recipientId: testUsers[4].cognitoId,
            })
            .expect(200));

        it("should find everyone unless I've sent them a request", () =>
          request(Server)
            .get("/user/explore")
            .query({ offset: 0, limit: 50 })
            .set("Authorization", header)
            .expect(200)
            .then((res: request.Response) => {
              expect(res.body.length).equal(3);
              for (let i = 0; i < 3; i++) {
                for (let k = 0; k < 3; k++) {
                  if (res.body[k].cognitoId == testUsers[i].cognitoId) {
                    comparePublicData(res.body[k], testUsers[i]);
                  }
                }
              }
            }));

        it("Block me", () =>
          request(Server)
            .post("/userRelationship/block")
            .set("Authorization", otherHeader)
            .send({
              recipientId: testUser.cognitoId,
            })
            .expect(200));

        it("should find everyone unless they've blocked me", () =>
          request(Server)
            .get("/user/explore")
            .query({ offset: 0, limit: 50 })
            .set("Authorization", header)
            .expect(200)
            .then((res: request.Response) => {
              expect(res.body.length).equal(2);
              for (let i = 0; i < 2; i++) {
                for (let k = 0; k < 2; k++) {
                  if (res.body[k].cognitoId == testUsers[i].cognitoId) {
                    comparePublicData(res.body[k], testUsers[i]);
                  }
                }
              }
            }));

        it("Unblock me", () =>
          request(Server)
            .post("/userRelationship/unblock")
            .set("Authorization", otherHeader)
            .send({
              recipientId: testUser.cognitoId,
            })
            .expect(200));

        it("should find everyone once they've unblocked me", () =>
          request(Server)
            .get("/user/explore")
            .query({ offset: 0, limit: 50 })
            .set("Authorization", header)
            .expect(200)
            .then((res: request.Response) => {
              expect(res.body.length).equal(3);
              for (let i = 0; i < 3; i++) {
                for (let k = 0; k < 3; k++) {
                  if (res.body[k].cognitoId == testUsers[i].cognitoId) {
                    comparePublicData(res.body[k], testUsers[i]);
                  }
                }
              }
            }));

        it("send me a friend request", () =>
          request(Server)
            .post("/userRelationship/sendRequest")
            .set("Authorization", otherHeader)
            .send({
              recipientId: testUser.cognitoId,
            })
            .expect(200));

        it("should still find people who have sent me a friend request", () =>
          request(Server)
            .get("/user/explore")
            .query({ offset: 0, limit: 50 })
            .set("Authorization", header)
            .expect(200)
            .then((res: request.Response) => {
              expect(res.body.length).equal(3);
              for (let i = 0; i < 3; i++) {
                for (let k = 0; k < 3; k++) {
                  if (res.body[k].cognitoId == testUsers[i].cognitoId) {
                    comparePublicData(res.body[k], testUsers[i]);
                  }
                }
              }
            }));

        it("deny my friend request", () =>
          request(Server)
            .post("/userRelationship/denyRequest")
            .set("Authorization", otherHeader)
            .send({
              recipientId: testUser.cognitoId,
            })
            .expect(200));

        it("should not find people who have denied my friend request", () =>
          request(Server)
            .get("/user/explore")
            .query({ offset: 0, limit: 50 })
            .set("Authorization", header)
            .expect(200)
            .then((res: request.Response) => {
              expect(res.body.length).equal(2);
              for (let i = 0; i < 2; i++) {
                for (let k = 0; k < 2; k++) {
                  if (res.body[k].cognitoId == testUsers[i].cognitoId) {
                    comparePublicData(res.body[k], testUsers[i]);
                  }
                }
              }
            }));
      });
    });
  });
});
