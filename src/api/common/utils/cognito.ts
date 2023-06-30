import { APIGatewayEvent } from "aws-lambda";

export type AdminCognitoClaims = {
  email: string;
  sub: string;
};

export type UserCognitoClaims = {
  email: string;
  sub: string;
};

export function getAdminClaims(
  event: APIGatewayEvent
): AdminCognitoClaims | null {
  if (
    event.requestContext.authorizer &&
    event.requestContext.authorizer.jwt &&
    event.requestContext.authorizer.jwt.claims
  ) {
    const claims: AdminCognitoClaims =
      event.requestContext.authorizer.jwt.claims;
    if (claims.email && claims.sub) {
      return claims;
    }
  }
  return null;
}

export function getUserClaims(
  event: APIGatewayEvent
): UserCognitoClaims | null {
  if (
    event.requestContext.authorizer &&
    event.requestContext.authorizer.jwt &&
    event.requestContext.authorizer.jwt.claims
  ) {
    const claims: UserCognitoClaims =
      event.requestContext.authorizer.jwt.claims;
    if (claims.email && claims.sub) {
      return claims;
    }
  }
  return null;
}
