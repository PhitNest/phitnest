import pino from "pino";
import { getEnv } from "./env";

const l = pino({
  name: getEnv().APP_ID,
  level: getEnv().LOG_LEVEL,
});

export { l };
