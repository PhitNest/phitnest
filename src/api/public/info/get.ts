import {
  handleRequest,
  environmentVars,
  RequestError,
  kInvalidBackendConfig,
  Success,
} from "api/common/utils";
import { APIGatewayProxyResult } from "aws-lambda";

export async function invoke(): Promise<APIGatewayProxyResult> {
  return await handleRequest(async () => {
    const {
      USER_POOL_ID,
      USER_POOL_CLIENT_ID,
      ADMIN_POOL_ID,
      ADMIN_POOL_CLIENT_ID,
      USER_IDENTITY_POOL_ID,
      USER_S3_BUCKET,
    } = environmentVars;
    if (!ADMIN_POOL_CLIENT_ID) {
      return new RequestError(
        kInvalidBackendConfig,
        "Unable to find admin pool client id"
      );
    }
    if (!ADMIN_POOL_ID) {
      return new RequestError(
        kInvalidBackendConfig,
        "Unable to find admin pool id"
      );
    }
    if (!USER_POOL_CLIENT_ID) {
      return new RequestError(
        kInvalidBackendConfig,
        "Unable to find user pool client id"
      );
    }
    if (!USER_POOL_ID) {
      return new RequestError(
        kInvalidBackendConfig,
        "Unable to find user pool id"
      );
    }
    if (!USER_IDENTITY_POOL_ID) {
      return new RequestError(
        kInvalidBackendConfig,
        "Unable to find user identity pool id"
      );
    }
    if (!USER_S3_BUCKET) {
      return new RequestError(
        kInvalidBackendConfig,
        "Unable to find user s3 bucket"
      );
    }
    return new Success({
      userPoolId: USER_POOL_ID,
      userClientId: USER_POOL_CLIENT_ID,
      adminPoolId: ADMIN_POOL_ID,
      adminClientId: ADMIN_POOL_CLIENT_ID,
      userIdentityPoolId: USER_IDENTITY_POOL_ID,
      userBucketName: USER_S3_BUCKET,
    });
  });
}
