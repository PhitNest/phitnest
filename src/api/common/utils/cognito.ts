import { APIGatewayEvent } from "aws-lambda";

export type AdminCognitoClaims = {
  email: string;
  sub: string;
};

export type UserCognitoClaims = {
  email: string;
  sub: string;
  firstName: string;
  lastName: string;
};

export function getAdminClaims(
  event: APIGatewayEvent
): AdminCognitoClaims | null {
  if (
    event.requestContext.authorizer &&
    event.requestContext.authorizer.claims
  ) {
    const claims: AdminCognitoClaims = event.requestContext.authorizer.claims;
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
    event.requestContext.authorizer.claims
  ) {
    const claims: UserCognitoClaims = event.requestContext.authorizer.claims;
    if (claims.email && claims.sub && claims.firstName && claims.lastName) {
      return claims;
    }
  }
  return null;
}
