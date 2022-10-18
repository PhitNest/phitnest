import { Application } from "express";
import authRouter from "./src/controllers/auth/router";
import gymRouter from "./src/controllers/gym/router";

export default function routes(app: Application): void {
  app.use("/auth", authRouter);
  app.use("/gym", gymRouter);
}
