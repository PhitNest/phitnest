import { RequestError } from "./request-handling";

export class EnvironmentVarsError extends RequestError {
  constructor(varName: string) {
    super(
      "EnvironmentVarsError",
      `Unable to find environment variable: ${varName}`
    );
  }
}

function getEnvVar(varName: string): string {
  const envVar = process.env[varName];
  if (envVar) {
    return envVar;
  } else {
    throw new EnvironmentVarsError(varName);
  }
}

export class EnvironmentVars {
  static dynamoTableName() {
    return getEnvVar("DYNAMO_TABLE_NAME");
  }

  static userPoolId() {
    return getEnvVar("USER_POOL_ID");
  }

  static userPoolClientId() {
    return getEnvVar("USER_POOL_CLIENT_ID");
  }

  static adminPoolId() {
    return getEnvVar("ADMIN_POOL_ID");
  }

  static adminPoolClientId() {
    return getEnvVar("ADMIN_POOL_CLIENT_ID");
  }

  static userIdentityPoolId() {
    return getEnvVar("USER_IDENTITY_POOL_ID");
  }

  static userS3BucketName() {
    return getEnvVar("USER_S3_BUCKET_NAME");
  }

  static region() {
    return getEnvVar("REGION");
  }
}
