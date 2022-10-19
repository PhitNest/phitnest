import dotenv, { DotenvConfigOutput } from "dotenv";
import l from "./logger";
const result: DotenvConfigOutput = dotenv.config();

export default () => {
  if (result.error) {
    l.error(
      "Could not find a valid .env file. Please try copying the contents of .env.example"
    );
    throw new Error("Invalid .env file");
  }
};
