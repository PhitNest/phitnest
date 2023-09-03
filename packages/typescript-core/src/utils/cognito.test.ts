import { mockPost } from "common/test-helpers";
import {
  AdminCognitoClaims,
  UserCognitoClaims,
  getAdminClaims,
  getUserClaims,
  kNoAuthorizer,
  kNoEmailClaim,
  kNoSubClaim,
} from "./cognito";

describe("getUserClaims", () => {
  it("should return a CognitoClaimsError if there is no authorizer", () => {
    expect(() => getUserClaims(mockPost({}))).toThrowError(kNoAuthorizer);
  });

  it("should return a CognitoClaimsError if there is no sub", () => {
    expect(() =>
      getUserClaims(
        mockPost({ authClaims: { email: "test" } as UserCognitoClaims }),
      ),
    ).toThrowError(kNoSubClaim);
  });

  it("should return a CognitoClaimsError if there is no email", () => {
    expect(() =>
      getUserClaims(
        mockPost({ authClaims: { sub: "test" } as UserCognitoClaims }),
      ),
    ).toThrowError(kNoEmailClaim);
  });

  it("should return the claims if they are valid", () => {
    expect(
      getUserClaims(
        mockPost({
          authClaims: {
            sub: "testSub",
            email: "testEmail",
          } as UserCognitoClaims,
        }),
      ),
    ).toEqual({ sub: "testSub", email: "testEmail" });
  });
});

describe("getAdminClaims", () => {
  it("should return a CognitoClaimsError if there is no authorizer", () => {
    expect(() => getAdminClaims(mockPost({}))).toThrowError(kNoAuthorizer);
  });

  it("should return a CognitoClaimsError if there is no sub", () => {
    expect(() =>
      getAdminClaims(
        mockPost({ authClaims: { email: "test" } as AdminCognitoClaims }),
      ),
    ).toThrowError(kNoSubClaim);
  });

  it("should return a CognitoClaimsError if there is no email", () => {
    expect(() =>
      getAdminClaims(
        mockPost({ authClaims: { sub: "test" } as AdminCognitoClaims }),
      ),
    ).toThrowError(kNoEmailClaim);
  });

  it("should return the claims if they are valid", () => {
    expect(
      getAdminClaims(
        mockPost({
          authClaims: {
            sub: "testSub",
            email: "testEmail",
          } as AdminCognitoClaims,
        }),
      ),
    ).toEqual({ sub: "testSub", email: "testEmail" });
  });
});
