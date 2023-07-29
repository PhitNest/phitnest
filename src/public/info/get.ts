import { APIGatewayProxyResult } from "aws-lambda";
import { EnvironmentVars, handleRequest, Success } from "common/utils";

export async function invoke(): Promise<APIGatewayProxyResult> {
  return await handleRequest(async () => {
    return new Success({
      userPoolId: EnvironmentVars.userPoolId(),
      userClientId: EnvironmentVars.userPoolClientId(),
      adminPoolId: EnvironmentVars.adminPoolId(),
      adminClientId: EnvironmentVars.adminPoolClientId(),
      userIdentityPoolId: EnvironmentVars.userIdentityPoolId(),
      userBucketName: EnvironmentVars.userS3BucketName(),
    });
  });
}
