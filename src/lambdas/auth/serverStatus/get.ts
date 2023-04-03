export async function invoke(): Promise<{
  statusCode: number;
  body: string;
}> {
  return {
    statusCode: 200,
    body:
      process.env.NODE_ENV == "production" &&
      process.env.COGNITO_USER_POOL_ID &&
      process.env.COGNITO_USER_POOL_APP_ID
        ? JSON.stringify({
            userPoolId: process.env.COGNITO_USER_POOL_ID,
            clientId: process.env.COGNITO_USER_POOL_APP_ID,
          })
        : "sandbox",
  };
}
