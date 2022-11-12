import { Application } from "express";
import authRouter from "./src/controllers/auth/router";
import userRouter from "./src/controllers/user/router";
import gymRouter from "./src/controllers/gym/router";
import userRelationshipRouter from "./src/controllers/userRelationships/router";

export default function routes(app: Application): void {
  app.use("/auth", authRouter);
  app.use("/gym", gymRouter);
  app.use("/user", userRouter);
  app.use("/userRelationship", userRelationshipRouter);
}
