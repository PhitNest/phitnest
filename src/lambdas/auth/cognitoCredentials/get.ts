export async function invoke(): Promise<{
  statusCode: number;
  body: string;
}> {
  return {
    statusCode: 200,
    body: JSON.stringify({
      userPoolId:
        (process.env.NODE_ENV == "development"
          ? null
          : process.env.COGNITO_USER_POOL_ID) ?? "sandbox",
      clientId:
        (process.env.NODE_ENV == "development"
          ? null
          : process.env.COGNITO_USER_POOL_APP_ID) ?? "sandbox",
    }),
  };
}
