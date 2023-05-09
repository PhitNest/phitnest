import {
  AccountRecovery,
  BooleanAttribute,
  UserPool,
  UserPoolClient,
  UserPoolEmail,
} from "@aws-cdk/aws-cognito";
import { RemovalPolicy } from "@aws-cdk/core";
import { DEPLOYMENT_ENV, PhitnestApiStack } from "./phitnest-api-stack";
import { HttpUserPoolAuthorizer } from "@aws-cdk/aws-apigatewayv2-authorizers";

export class CognitoStack {
  public readonly cognitoAuthorizer: HttpUserPoolAuthorizer;

  constructor(scope: PhitnestApiStack) {
    const userPool = new UserPool(scope, `PhitnestUserPool-${DEPLOYMENT_ENV}`, {
      userPoolName: `Phitnest-User-Pool-${DEPLOYMENT_ENV}`,
      selfSignUpEnabled: true,
      signInAliases: {
        email: true,
        username: false,
      },
      accountRecovery: AccountRecovery.EMAIL_ONLY,
      email: UserPoolEmail.withSES({
        fromEmail: "verify@phitnest.com",
        fromName: "Phitnest Verification",
        replyTo: "verify@phitnest.com",
        sesVerifiedDomain: "phitnest.com",
      }),
      customAttributes: {
        admin: new BooleanAttribute({ mutable: true }),
      },
    });
    userPool.applyRemovalPolicy(RemovalPolicy.DESTROY);
    const client = new UserPoolClient(
      scope,
      `PhitnestUserPoolClient-${DEPLOYMENT_ENV}`,
      { userPool: userPool }
    );
    client.applyRemovalPolicy(RemovalPolicy.DESTROY);
    this.cognitoAuthorizer = new HttpUserPoolAuthorizer(
      `PhitnestCognitoAuthorizer-${DEPLOYMENT_ENV}`,
      userPool,
      {
        userPoolClients: [client],
        identitySource: ["$request.header.Authorization"],
      }
    );
  }
}
