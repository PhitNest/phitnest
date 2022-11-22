import dotenv from "dotenv";
dotenv.config();

export type Environment = {
  PORT: number;
  MONGODB_CONN_STRING: string;
  COGNITO_POOL_ID: string;
  COGNITO_APP_CLIENT_ID: string;
};

export let env: Environment;

try {
  env = {
    PORT: parseInt(process.env.PORT!),
    MONGODB_CONN_STRING: process.env.MONGODB_CONN_STRING!,
    COGNITO_POOL_ID: process.env.COGNITO_POOL_ID!,
    COGNITO_APP_CLIENT_ID: process.env.COGNITO_APP_CLIENT!,
  };
} catch (err) {
  throw new Error("Could not parse environment variables.");
}
