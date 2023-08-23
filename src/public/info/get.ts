import { APIGatewayProxyResult } from "aws-lambda";
import { EnvironmentVars, handleRequest, Success } from "common/utils";

export async function invoke(): Promise<APIGatewayProxyResult> {
  return await handleRequest(async () => {
    return new Success({
      userPool: {
        poolId: EnvironmentVars.userPoolId(),
        clientId: EnvironmentVars.userPoolClientId(),
      },
      adminPool: {
        poolId: EnvironmentVars.adminPoolId(),
        clientId: EnvironmentVars.adminPoolClientId(),
      },
      userIdentityPoolId: EnvironmentVars.userIdentityPoolId(),
      userBucketName: EnvironmentVars.userS3BucketName(),
    });
  });
}
