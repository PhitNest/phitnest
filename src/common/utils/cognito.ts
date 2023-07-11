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
    super("COGNITO_CLAIMS_ERROR", message);
  }
}

export function getAdminClaims(
  event: APIGatewayEvent
): AdminCognitoClaims | CognitoClaimsError {
  if (
    event.requestContext.authorizer &&
    event.requestContext.authorizer.jwt &&
    event.requestContext.authorizer.jwt.claims
  ) {
    const claims: AdminCognitoClaims =
      event.requestContext.authorizer.jwt.claims;
    if (!claims.email) {
      return new CognitoClaimsError("No email claim");
    }
    if (!claims.sub) {
      return new CognitoClaimsError("No sub claim");
    }
    return claims;
  }
  return new CognitoClaimsError("No authorizer");
}

export function getUserClaims(
  event: APIGatewayEvent
): UserCognitoClaims | CognitoClaimsError {
  if (
    event.requestContext.authorizer &&
    event.requestContext.authorizer.jwt &&
    event.requestContext.authorizer.jwt.claims
  ) {
    const claims: UserCognitoClaims =
      event.requestContext.authorizer.jwt.claims;
    if (!claims.email) {
      return new CognitoClaimsError("No email claim");
    }
    if (!claims.sub) {
      return new CognitoClaimsError("No sub claim");
    }
    return claims;
  }
  return new CognitoClaimsError("No authorizer");
}
