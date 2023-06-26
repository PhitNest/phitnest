type EnvironmentVars = {
  USER_POOL_ID: string | undefined;
  USER_POOL_CLIENT_ID: string | undefined;
  ADMIN_POOL_ID: string | undefined;
  ADMIN_POOL_CLIENT_ID: string | undefined;
  USER_IDENTITY_POOL_ID: string | undefined;
  USER_S3_BUCKET: string | undefined;
};

export const environmentVars = process.env as EnvironmentVars;
