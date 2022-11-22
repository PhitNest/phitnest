import dotenv from "dotenv";

export type Environment = {
  PORT: number;
  MONGODB_CONN_STRING: string;
  COGNITO_POOL_ID: string;
  COGNITO_APP_CLIENT_ID: string;
};

let env: Environment;

export function getEnv(): Environment {
  if (!env) {
    dotenv.config();
    try {
      env = {
        PORT: parseInt(process.env.PORT!),
        MONGODB_CONN_STRING: process.env.MONGODB_CONN_STRING!,
        COGNITO_POOL_ID: process.env.COGNITO_POOL_ID!,
        COGNITO_APP_CLIENT_ID: process.env.COGNITO_APP_CLIENT_ID!,
      };
    } catch (err) {
      throw new Error("Could not parse environment variables.");
    }
  }
  return env;
}
