import dotenv from "dotenv";

export type Environment = {
  PORT: number;
  MONGODB_CONN_STRING: string;
  COGNITO_POOL_ID: string;
  COGNITO_APP_CLIENT_ID: string;
  APP_ID: any;
  LOG_LEVEL: string;
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
        APP_ID: process.env.APP_ID,
        LOG_LEVEL: process.env.LOG_LEVEL || "debug",
      };
    } catch (err) {
      throw new Error("Could not parse environment variables.");
    }
  }
  return env;
}
