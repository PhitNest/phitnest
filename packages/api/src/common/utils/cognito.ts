import { APIGatewayEvent } from "aws-lambda";
import { RequestError } from "./request-handling";

export type AdminCognitoClaims = {
  email: string;
  sub: string;
};

export type UserCognitoClaims = AdminCognitoClaims & {
  email: string;
  sub: string;
};

export class CognitoClaimsError extends RequestError {
  constructor(message: string) {
    super("CognitoClaimsError", message);
  }
}

export const kNoEmailClaim = new CognitoClaimsError("No email claim");
export const kNoSubClaim = new CognitoClaimsError("No sub claim");
export const kNoAuthorizer = new CognitoClaimsError("No authorizer");

function checkClaims<Claims extends object>(
  event: APIGatewayEvent,
  extractClaims: (claims: Claims) => Claims,
): Claims {
  if (
    event.requestContext.authorizer &&
    event.requestContext.authorizer.claims
  ) {
    return extractClaims(event.requestContext.authorizer.claims);
  } else {
    throw kNoAuthorizer;
  }
}

export function getAdminClaims(event: APIGatewayEvent): AdminCognitoClaims {
  return checkClaims(event, (claims) => {
    if (!claims.email) {
      throw kNoEmailClaim;
    }
    if (!claims.sub) {
      throw kNoSubClaim;
    }
    return claims;
  });
}

export function getUserClaims(event: APIGatewayEvent): UserCognitoClaims {
  return checkClaims(event, (claims) => {
    if (!claims.email) {
      throw kNoEmailClaim;
    }
    if (!claims.sub) {
      throw kNoSubClaim;
    }
    return claims;
  });
}
