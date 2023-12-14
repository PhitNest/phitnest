import { APIGatewayEvent } from "aws-lambda";
import { RequestError, requestError } from "./request-handling";

export type AdminCognitoClaims = {
  email: string;
  sub: string;
};

export type UserCognitoClaims = AdminCognitoClaims & {
  email: string;
  sub: string;
};

const kCognitoClaimsError = "CognitoClaimsError";

export function cognitoClaimsError(
  message: string
): RequestError<typeof kCognitoClaimsError> {
  return requestError(kCognitoClaimsError, message);
}

export const kNoEmailClaim = cognitoClaimsError("No email claim");
export const kNoSubClaim = cognitoClaimsError("No sub claim");
export const kNoAuthorizer = cognitoClaimsError("No authorizer");

function checkClaims<Claims extends object>(
  event: APIGatewayEvent,
  extractClaims: (claims: Claims) => Claims
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
